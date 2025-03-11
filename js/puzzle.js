/**
 * MyPuzzle - HTML5 Puzzle Game
 * Main JavaScript file handling all game logic
 */

// DOM Elements
const imageUpload = document.getElementById('imageUpload');
const originalImage = document.getElementById('original-image');
const puzzleContainer = document.getElementById('puzzle-container');
const difficultySelect = document.getElementById('difficulty');
const startGameBtn = document.getElementById('startGame');
const resetGameBtn = document.getElementById('resetGame');
const completionMessage = document.getElementById('completion-message');
const playAgainBtn = document.getElementById('playAgain');
const loadingOverlay = document.getElementById('loading-overlay');

// Game State
let gameState = {
    originalImageSrc: null,
    difficulty: 4,
    pieces: [],
    pieceWidth: 0,
    pieceHeight: 0,
    puzzleWidth: 0,
    puzzleHeight: 0,
    isPlaying: false,
    correctPieces: 0,
    totalPieces: 0
};

// Event Listeners
document.addEventListener('DOMContentLoaded', initGame);

// Initialize Game
function initGame() {
    imageUpload.addEventListener('change', handleImageUpload);
    difficultySelect.addEventListener('change', updateDifficulty);
    startGameBtn.addEventListener('click', startGame);
    resetGameBtn.addEventListener('click', resetGame);
    playAgainBtn.addEventListener('click', resetGame);
}

// Handle Image Upload
function handleImageUpload(e) {
    const file = e.target.files[0];
    if (!file) return;
    
    // Show loading overlay
    loadingOverlay.classList.remove('hidden');
    
    // Check if file is an image
    if (!file.type.match('image.*')) {
        alert('Please select an image file.');
        loadingOverlay.classList.add('hidden');
        return;
    }
    
    const reader = new FileReader();
    
    reader.onload = function(event) {
        const img = new Image();
        img.onload = function() {
            // Store original image source
            gameState.originalImageSrc = event.target.result;
            
            // Display original image
            originalImage.innerHTML = '';
            originalImage.appendChild(img.cloneNode());
            
            // Enable start button
            startGameBtn.disabled = false;
            
            // Hide loading overlay
            loadingOverlay.classList.add('hidden');
        };
        
        img.src = event.target.result;
    };
    
    reader.readAsDataURL(file);
}

// Update Difficulty
function updateDifficulty() {
    gameState.difficulty = parseInt(difficultySelect.value);
}

// Start Game
function startGame() {
    if (!gameState.originalImageSrc) return;
    
    // Show loading overlay
    loadingOverlay.classList.remove('hidden');
    
    // Set game state
    gameState.isPlaying = true;
    gameState.correctPieces = 0;
    gameState.totalPieces = gameState.difficulty * gameState.difficulty;
    
    // Enable reset button
    resetGameBtn.disabled = false;
    
    // Create puzzle pieces
    createPuzzlePieces();
    
    // Hide loading overlay after a short delay to ensure DOM updates
    setTimeout(() => {
        loadingOverlay.classList.add('hidden');
    }, 500);
}

// Create Puzzle Pieces
function createPuzzlePieces() {
    // Clear puzzle container
    puzzleContainer.innerHTML = '';
    
    // Set puzzle container dimensions
    const containerWidth = puzzleContainer.clientWidth;
    const containerHeight = puzzleContainer.clientHeight;
    
    // Calculate piece dimensions
    gameState.pieceWidth = containerWidth / gameState.difficulty;
    gameState.pieceHeight = containerHeight / gameState.difficulty;
    gameState.puzzleWidth = containerWidth;
    gameState.puzzleHeight = containerHeight;
    
    // Calculate the offset to center the puzzle in the container
    const offsetX = (containerWidth - gameState.puzzleWidth) / 2;
    const offsetY = (containerHeight - gameState.puzzleHeight) / 2;
    
    // Create temporary image to get dimensions
    const tempImg = new Image();
    tempImg.onload = function() {
        // Create canvas to draw the image
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        
        // Set canvas dimensions to match puzzle container
        canvas.width = containerWidth;
        canvas.height = containerHeight;
        
        // Draw image on canvas, scaled to fit
        ctx.drawImage(tempImg, 0, 0, containerWidth, containerHeight);
        
        // Create pieces array
        gameState.pieces = [];
        
        // Generate pieces
        for (let row = 0; row < gameState.difficulty; row++) {
            for (let col = 0; col < gameState.difficulty; col++) {
                // Create piece canvas
                const pieceCanvas = document.createElement('canvas');
                pieceCanvas.width = gameState.pieceWidth;
                pieceCanvas.height = gameState.pieceHeight;
                const pieceCtx = pieceCanvas.getContext('2d');
                
                // Draw portion of original image on piece canvas
                pieceCtx.drawImage(
                    canvas, 
                    col * gameState.pieceWidth, 
                    row * gameState.pieceHeight, 
                    gameState.pieceWidth, 
                    gameState.pieceHeight,
                    0, 
                    0, 
                    gameState.pieceWidth, 
                    gameState.pieceHeight
                );
                
                // Calculate correct position with offset
                const correctX = offsetX + col * gameState.pieceWidth;
                const correctY = offsetY + row * gameState.pieceHeight;
                
                // Create piece object
                const piece = {
                    id: row * gameState.difficulty + col,
                    row: row,
                    col: col,
                    currentRow: row,
                    currentCol: col,
                    x: correctX,
                    y: correctY,
                    correctX: correctX,
                    correctY: correctY,
                    width: gameState.pieceWidth,
                    height: gameState.pieceHeight,
                    image: pieceCanvas.toDataURL()
                };
                
                gameState.pieces.push(piece);
            }
        }
        
        // Shuffle pieces
        shufflePieces();
        
        // Render pieces
        renderPieces();
    };
    
    tempImg.src = gameState.originalImageSrc;
}

// Shuffle Pieces
function shufflePieces() {
    const containerWidth = puzzleContainer.clientWidth;
    const containerHeight = puzzleContainer.clientHeight;
    
    // Distribute pieces randomly across the puzzle container
    gameState.pieces.forEach(piece => {
        // Generate random position within the container boundaries
        // but leave some margin to ensure pieces are not placed too close to the edges
        const margin = 20;
        const maxX = containerWidth - piece.width - margin;
        const maxY = containerHeight - piece.height - margin;
        
        // Random position with margin
        piece.x = margin + Math.random() * maxX;
        piece.y = margin + Math.random() * maxY;
        
        // Update current row and column (approximate)
        piece.currentRow = Math.floor(piece.y / gameState.pieceHeight);
        piece.currentCol = Math.floor(piece.x / gameState.pieceWidth);
    });
}

// Render Pieces
function renderPieces() {
    // Clear puzzle container
    puzzleContainer.innerHTML = '';
    
    // Create and append piece elements
    gameState.pieces.forEach(piece => {
        const pieceElement = document.createElement('div');
        pieceElement.className = 'puzzle-piece';
        pieceElement.dataset.id = piece.id;
        
        // Set piece position and dimensions
        pieceElement.style.width = `${piece.width}px`;
        pieceElement.style.height = `${piece.height}px`;
        pieceElement.style.left = `${piece.x}px`;
        pieceElement.style.top = `${piece.y}px`;
        pieceElement.style.backgroundImage = `url(${piece.image})`;
        
        // Check if piece is in correct position
        if (piece.x === piece.correctX && piece.y === piece.correctY) {
            pieceElement.classList.add('correct');
        }
        
        // Add drag functionality
        makeDraggable(pieceElement);
        
        // Append to puzzle container
        puzzleContainer.appendChild(pieceElement);
    });
}

// Make Element Draggable
function makeDraggable(element) {
    let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
    let isDragging = false;
    
    element.onmousedown = dragMouseDown;
    element.ontouchstart = dragTouchStart;
    
    function dragMouseDown(e) {
        e.preventDefault();
        
        // Get mouse position
        pos3 = e.clientX;
        pos4 = e.clientY;
        
        // Bring piece to front and add dragging class
        element.style.zIndex = '100';
        element.classList.add('dragging');
        
        // Set dragging flag
        isDragging = true;
        
        // Add event listeners for drag and release
        document.onmousemove = elementDrag;
        document.onmouseup = closeDragElement;
    }
    
    function dragTouchStart(e) {
        e.preventDefault();
        
        // Get touch position
        pos3 = e.touches[0].clientX;
        pos4 = e.touches[0].clientY;
        
        // Bring piece to front and add dragging class
        element.style.zIndex = '100';
        element.classList.add('dragging');
        
        // Set dragging flag
        isDragging = true;
        
        // Add event listeners for drag and release
        document.ontouchmove = elementTouchDrag;
        document.ontouchend = closeTouchDragElement;
    }
    
    function elementDrag(e) {
        e.preventDefault();
        
        // Calculate new position
        pos1 = pos3 - e.clientX;
        pos2 = pos4 - e.clientY;
        pos3 = e.clientX;
        pos4 = e.clientY;
        
        // Set new position
        element.style.top = `${element.offsetTop - pos2}px`;
        element.style.left = `${element.offsetLeft - pos1}px`;
    }
    
    function elementTouchDrag(e) {
        e.preventDefault();
        
        // Calculate new position
        pos1 = pos3 - e.touches[0].clientX;
        pos2 = pos4 - e.touches[0].clientY;
        pos3 = e.touches[0].clientX;
        pos4 = e.touches[0].clientY;
        
        // Set new position
        element.style.top = `${element.offsetTop - pos2}px`;
        element.style.left = `${element.offsetLeft - pos1}px`;
    }
    
    function closeDragElement() {
        // Stop tracking mouse movement
        document.onmouseup = null;
        document.onmousemove = null;
        
        // Reset z-index and remove dragging class
        element.style.zIndex = '1';
        element.classList.remove('dragging');
        
        // Check if piece is in correct position
        if (isDragging) {
            checkPiecePosition(element);
            isDragging = false;
        }
    }
    
    function closeTouchDragElement() {
        // Stop tracking touch movement
        document.ontouchend = null;
        document.ontouchmove = null;
        
        // Reset z-index and remove dragging class
        element.style.zIndex = '1';
        element.classList.remove('dragging');
        
        // Check if piece is in correct position
        if (isDragging) {
            checkPiecePosition(element);
            isDragging = false;
        }
    }
}

// Check Piece Position
function checkPiecePosition(element) {
    const pieceId = parseInt(element.dataset.id);
    const piece = gameState.pieces.find(p => p.id === pieceId);
    
    // Get current position
    const currentX = parseInt(element.style.left);
    const currentY = parseInt(element.style.top);
    
    // Update piece data with exact position (no snapping to grid)
    piece.x = currentX;
    piece.y = currentY;
    
    // Check if piece is close enough to its correct position
    const isCloseToCorrect = (
        Math.abs(piece.x - piece.correctX) < gameState.pieceWidth / 4 && 
        Math.abs(piece.y - piece.correctY) < gameState.pieceHeight / 4
    );
    
    // If piece is close to correct position, snap it
    if (isCloseToCorrect) {
        // Snap to correct position
        element.style.left = `${piece.correctX}px`;
        element.style.top = `${piece.correctY}px`;
        
        // Update piece data
        piece.x = piece.correctX;
        piece.y = piece.correctY;
        
        // Add correct class
        element.classList.add('correct');
        
        // Check if this is a newly correct piece
        if (!element.classList.contains('counted')) {
            element.classList.add('counted');
            gameState.correctPieces++;
            
            // Check if puzzle is complete
            if (gameState.correctPieces === gameState.totalPieces) {
                setTimeout(showCompletionMessage, 500);
            }
        }
    } else {
        element.classList.remove('correct');
        
        // If piece was previously correct, decrement counter
        if (element.classList.contains('counted')) {
            element.classList.remove('counted');
            gameState.correctPieces--;
        }
    }
}

// Show Completion Message
function showCompletionMessage() {
    completionMessage.classList.remove('hidden');
    
    // Add celebration animation to puzzle container
    puzzleContainer.style.animation = 'celebrate 0.5s ease-in-out 3';
}

// Reset Game
function resetGame() {
    // Hide completion message
    completionMessage.classList.add('hidden');
    
    // Reset game state
    gameState.isPlaying = false;
    gameState.correctPieces = 0;
    
    // Clear puzzle container
    puzzleContainer.innerHTML = '<p>Puzzle will be generated here</p>';
    
    // Reset puzzle container animation
    puzzleContainer.style.animation = 'none';
    
    // Disable reset button
    resetGameBtn.disabled = true;
    
    // If we have an image, enable start button
    startGameBtn.disabled = !gameState.originalImageSrc;
} 