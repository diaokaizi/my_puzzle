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
    totalPieces: 0,
    mergedGroups: []
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
    gameState.mergedGroups = [];
    
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
                    image: pieceCanvas.toDataURL(),
                    groupId: row * gameState.difficulty + col,
                    adjacentPieces: []
                };
                
                gameState.pieces.push(piece);
            }
        }
        
        // Calculate each piece's adjacent pieces
        calculateAdjacentPieces();
        
        // Shuffle pieces
        shufflePieces();
        
        // Render pieces
        renderPieces();
    };
    
    tempImg.src = gameState.originalImageSrc;
}

// Calculate each piece's adjacent pieces
function calculateAdjacentPieces() {
    gameState.pieces.forEach(piece => {
        // Top piece
        if (piece.row > 0) {
            piece.adjacentPieces.push({
                id: (piece.row - 1) * gameState.difficulty + piece.col,
                direction: 'top'
            });
        }
        
        // Bottom piece
        if (piece.row < gameState.difficulty - 1) {
            piece.adjacentPieces.push({
                id: (piece.row + 1) * gameState.difficulty + piece.col,
                direction: 'bottom'
            });
        }
        
        // Left piece
        if (piece.col > 0) {
            piece.adjacentPieces.push({
                id: piece.row * gameState.difficulty + (piece.col - 1),
                direction: 'left'
            });
        }
        
        // Right piece
        if (piece.col < gameState.difficulty - 1) {
            piece.adjacentPieces.push({
                id: piece.row * gameState.difficulty + (piece.col + 1),
                direction: 'right'
            });
        }
    });
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
    
    // 获取所有唯一的组ID
    const uniqueGroupIds = [...new Set(gameState.pieces.map(piece => piece.groupId))];
    
    // 为每个组创建一个元素
    uniqueGroupIds.forEach(groupId => {
        // 获取该组的所有碎片
        const groupPieces = gameState.pieces.filter(piece => piece.groupId === groupId);
        
        // 如果组中只有一个碎片，直接渲染
        if (groupPieces.length === 1) {
            const piece = groupPieces[0];
            const pieceElement = document.createElement('div');
            pieceElement.className = 'puzzle-piece';
            pieceElement.dataset.id = piece.id;
            pieceElement.dataset.groupId = piece.groupId;
            
            // Set piece position and dimensions
            pieceElement.style.width = `${piece.width}px`;
            pieceElement.style.height = `${piece.height}px`;
            pieceElement.style.left = `${piece.x}px`;
            pieceElement.style.top = `${piece.y}px`;
            pieceElement.style.backgroundImage = `url(${piece.image})`;
            
            // Add drag functionality
            makeDraggable(pieceElement);
            
            // Append to puzzle container
            puzzleContainer.appendChild(pieceElement);
        } else {
            // 创建合并组的元素
            const groupElement = document.createElement('div');
            groupElement.className = 'puzzle-piece merged-group';
            groupElement.dataset.groupId = groupId;
            
            // 找出组中的第一个碎片作为参考点
            const firstPiece = groupPieces[0];
            
            // 计算合并组的尺寸和位置
            let minX = Infinity, minY = Infinity;
            let maxX = -Infinity, maxY = -Infinity;
            
            // 找出组中所有碎片的边界
            groupPieces.forEach(piece => {
                const pieceRight = piece.x + piece.width;
                const pieceBottom = piece.y + piece.height;
                
                minX = Math.min(minX, piece.x);
                minY = Math.min(minY, piece.y);
                maxX = Math.max(maxX, pieceRight);
                maxY = Math.max(maxY, pieceBottom);
            });
            
            // 设置合并组的尺寸和位置
            const groupWidth = maxX - minX;
            const groupHeight = maxY - minY;
            
            groupElement.style.width = `${groupWidth}px`;
            groupElement.style.height = `${groupHeight}px`;
            groupElement.style.left = `${minX}px`;
            groupElement.style.top = `${minY}px`;
            
            // 为合并组中的每个碎片创建一个子元素
            groupPieces.forEach(piece => {
                const subPieceElement = document.createElement('div');
                subPieceElement.className = 'sub-piece';
                subPieceElement.dataset.id = piece.id;
                
                // 计算子碎片相对于合并组的位置
                const relativeX = piece.x - minX;
                const relativeY = piece.y - minY;
                
                // 设置子碎片的样式
                subPieceElement.style.width = `${piece.width}px`;
                subPieceElement.style.height = `${piece.height}px`;
                subPieceElement.style.left = `${relativeX}px`;
                subPieceElement.style.top = `${relativeY}px`;
                subPieceElement.style.backgroundImage = `url(${piece.image})`;
                subPieceElement.style.position = 'absolute';
                
                // 添加到合并组
                groupElement.appendChild(subPieceElement);
            });
            
            // 添加拖拽功能
            makeDraggable(groupElement);
            
            // 添加到拼图容器
            puzzleContainer.appendChild(groupElement);
        }
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
    // 获取元素的组ID
    const groupId = parseInt(element.dataset.groupId);
    
    // 获取该组的所有碎片
    const groupPieces = gameState.pieces.filter(piece => piece.groupId === groupId);
    
    // 获取当前位置
    const currentX = parseInt(element.style.left);
    const currentY = parseInt(element.style.top);
    
    // 更新组中所有碎片的位置
    groupPieces.forEach(piece => {
        if (groupPieces.length === 1) {
            // 单个碎片直接更新位置
            piece.x = currentX;
            piece.y = currentY;
        } else {
            // 合并组中的碎片，需要计算相对位置
            const subPieceElement = element.querySelector(`[data-id="${piece.id}"]`);
            if (subPieceElement) {
                const relativeX = parseInt(subPieceElement.style.left);
                const relativeY = parseInt(subPieceElement.style.top);
                piece.x = currentX + relativeX;
                piece.y = currentY + relativeY;
            }
        }
    });
    
    // 检查是否可以与其他碎片合并
    checkForMerge(groupId);
    
    // 检查拼图是否完成
    checkPuzzleCompletion();
}

// 新增：检查是否可以与其他碎片合并
function checkForMerge(groupId) {
    // 获取该组的所有碎片
    const groupPieces = gameState.pieces.filter(piece => piece.groupId === groupId);
    
    // 遍历组中的每个碎片
    for (const piece of groupPieces) {
        // 检查每个相邻的碎片
        for (const adjacent of piece.adjacentPieces) {
            // 获取相邻的碎片
            const adjacentPiece = gameState.pieces.find(p => p.id === adjacent.id);
            
            // 如果相邻碎片已经在同一组中，跳过
            if (adjacentPiece.groupId === piece.groupId) continue;
            
            // 检查两个碎片是否足够接近以合并
            const canMerge = checkPiecesCanMerge(piece, adjacentPiece, adjacent.direction);
            
            if (canMerge) {
                // 合并两个组
                mergePieceGroups(piece.groupId, adjacentPiece.groupId);
                
                // 播放合并音效或动画效果
                playMergeEffect();
                
                // 重新渲染碎片
                renderPieces();
                
                // 由于已经合并并重新渲染，退出函数
                return;
            }
        }
    }
}

// 新增：检查两个碎片是否可以合并
function checkPiecesCanMerge(piece1, piece2, direction) {
    const threshold = Math.min(gameState.pieceWidth, gameState.pieceHeight) / 5; // 合并阈值
    
    switch (direction) {
        case 'top':
            // piece2 应该在 piece1 的上方
            return (
                Math.abs(piece1.x - piece2.x) < threshold &&
                Math.abs(piece1.y - piece2.y - piece2.height) < threshold
            );
        case 'bottom':
            // piece2 应该在 piece1 的下方
            return (
                Math.abs(piece1.x - piece2.x) < threshold &&
                Math.abs(piece1.y + piece1.height - piece2.y) < threshold
            );
        case 'left':
            // piece2 应该在 piece1 的左侧
            return (
                Math.abs(piece1.x - piece2.x - piece2.width) < threshold &&
                Math.abs(piece1.y - piece2.y) < threshold
            );
        case 'right':
            // piece2 应该在 piece1 的右侧
            return (
                Math.abs(piece1.x + piece1.width - piece2.x) < threshold &&
                Math.abs(piece1.y - piece2.y) < threshold
            );
        default:
            return false;
    }
}

// 新增：合并两个碎片组
function mergePieceGroups(groupId1, groupId2) {
    // 获取两个组的所有碎片
    const group1Pieces = gameState.pieces.filter(piece => piece.groupId === groupId1);
    const group2Pieces = gameState.pieces.filter(piece => piece.groupId === groupId2);
    
    // 将第二组的所有碎片的组ID更改为第一组的ID
    group2Pieces.forEach(piece => {
        piece.groupId = groupId1;
    });
    
    // 添加到合并组记录中
    gameState.mergedGroups.push({
        groupId: groupId1,
        pieces: [...group1Pieces, ...group2Pieces].map(p => p.id)
    });
}

// 新增：播放合并效果
function playMergeEffect() {
    // 添加合并动画效果
    const mergedGroups = document.querySelectorAll('.merged-group');
    mergedGroups.forEach(group => {
        group.classList.add('merging');
        
        // 动画结束后移除类
        setTimeout(() => {
            group.classList.remove('merging');
        }, 300);
    });
    
    // 可以在这里添加音效
    // 例如：
    // const mergeSound = new Audio('sounds/merge.mp3');
    // mergeSound.play();
}

// 新增：检查拼图是否完成
function checkPuzzleCompletion() {
    // 获取所有唯一的组ID
    const uniqueGroupIds = [...new Set(gameState.pieces.map(piece => piece.groupId))];
    
    // 如果只有一个组，说明拼图已完成
    if (uniqueGroupIds.length === 1) {
        setTimeout(showCompletionMessage, 500);
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
    gameState.mergedGroups = []; // 重置合并组
    
    // Clear puzzle container
    puzzleContainer.innerHTML = '<p>Puzzle will be generated here</p>';
    
    // Reset puzzle container animation
    puzzleContainer.style.animation = 'none';
    
    // Disable reset button
    resetGameBtn.disabled = true;
    
    // If we have an image, enable start button
    startGameBtn.disabled = !gameState.originalImageSrc;
} 