import random
from typing import List
from copy import deepcopy

GRIDS = [

    #  All filled or all empty
    [[False, False], [False, False]], # 0 none
    [[True, True], [True, True]], # 1 all

    #  One missing
    [[False, True], [True, True]], # 2 top left
    [[True, False], [True, True]], # 3 top right
    [[True, True], [True, False]], # 4 bot right
    [[True, True], [False, True]], # 5 bot left

    #  Two missing
    [[True, False], [True, False]], # 6 left
    [[True, True], [False, False]], # 7 top
    [[False, True], [False, True]], # 8 right
    [[False, False], [True, True]], # 9 bottom

    [[True, False], [False, True]], # 10 Cross Negative
    [[False, True], [True, False]], # 11 Cross Positive

    # Three Missing
    [[True, False], [False, False]], # 12 top left
    [[False, True], [False, False]], # 13 top right
    [[False, False], [False, True]], # 14 bot right
    [[False, False], [True, False]]  # 15 bot left


]

def countCommon(grid1, grid2):

    count = 0
    for i in range(2):
        for j in range(2):
            if grid1[i][j] == True and grid2[i][j] == True:
                count += 1
    return count

GRID_OPTIONS = {
    0: [GRIDS[0]],
    1: [GRIDS[1]],

    2: [GRIDS[i] for i in range(len(GRIDS)) if (GRIDS[i][1][1] and (i != 10 and i != 11))],
    3: [GRIDS[i] for i in range(len(GRIDS)) if (GRIDS[i][0][1] and (i != 10 and i != 11))],
    4: [GRIDS[i] for i in range(len(GRIDS)) if (GRIDS[i][0][0] and (i != 10 and i != 11))],
    5: [GRIDS[i] for i in range(len(GRIDS)) if (GRIDS[i][1][0] and (i != 10 and i != 11))],

    6: [GRIDS[i] for i in range(len(GRIDS)) if (countCommon(GRIDS[6], GRIDS[i]) >= 1 and (i != 10 and i != 11))],
    7: [GRIDS[i] for i in range(len(GRIDS)) if (countCommon(GRIDS[6], GRIDS[i]) >= 1 and (i != 10 and i != 11))],
    8: [GRIDS[i] for i in range(len(GRIDS)) if (countCommon(GRIDS[6], GRIDS[i]) >= 1 and (i != 10 and i != 11))],
    9: [GRIDS[i] for i in range(len(GRIDS)) if (countCommon(GRIDS[6], GRIDS[i]) >= 1 and (i != 10 and i != 11))],

    10: [GRIDS[i] for i in range(len(GRIDS))if (countCommon(GRIDS[6], GRIDS[i]) >= 1 and (i != 10 and i != 11))],
    11: [GRIDS[i] for i in range(len(GRIDS))if (countCommon(GRIDS[6], GRIDS[i]) >= 1 and (i != 10 and i != 11))],

    12: [GRIDS[i] for i in range(len(GRIDS)) if (GRIDS[i][0][0] and (i != 10 and i != 11))],
    13: [GRIDS[i] for i in range(len(GRIDS)) if (GRIDS[i][1][0] and (i != 10 and i != 11))],
    14: [GRIDS[i] for i in range(len(GRIDS)) if (GRIDS[i][1][1] and (i != 10 and i != 11))],
    15: [GRIDS[i] for i in range(len(GRIDS)) if (GRIDS[i][0][1] and (i != 10 and i != 11))],

}

def determineGrid(grid):
    
    for i in range(len(GRIDS)):
        compare = GRIDS[i]

        match = True
        for x in range(2):
            for y in range(2):
                if grid[x][y] != compare[x][y]:
                    match = False

        if match:
            return i

def dilate(grid):
    newGrid = []
    for i in range(len(grid)):
        newRow = []
        for j in range(len(grid)):

            if i > 0 and grid[i-1][j]:
                newRow.append(True)
                continue
            if j > 0 and grid[i][j-1]:
                newRow.append(True)
                continue
            if i < len(grid) - 1 and grid[i+1][j]:
                newRow.append(True)
                continue
            if j < len(grid) - 1 and grid[i][j+1]:
                newRow.append(True)
                continue

            newRow.append(False)
        newGrid.append(newRow)
    return newGrid

def recede(grid):
    newGrid = []
    for i in range(len(grid)):
        newRow = []
        for j in range(len(grid)):

            if i == 0 or j == 0 or i == len(grid) - 1 or j == len(grid) - 1:
                newRow.append(False)
                continue

            if not grid[i-1][j]:
                newRow.append(False)
                continue
            if not grid[i][j-1]:
                newRow.append(False)
                continue
            if not grid[i+1][j]:
                newRow.append(False)
                continue
            if not grid[i][j+1]:
                newRow.append(False)
                continue
            if not grid[i][j]:
                newRow.append(False)
                continue

            newRow.append(True)
        newGrid.append(newRow)
    return newGrid

def generate(iterations: int):

    # random.seed(4)
    
    #  Track for when to break out
    currentIteration = 2

    #  The original case. Options are anything but all false
    center = deepcopy(random.choice(GRIDS[1:]))
    grid = [
        [False, False, False, False, False, False],
        [False, False, False, False, False, False],
        [False, False, center[0][0], center[1][0], False, False],
        [False, False, center[0][1], center[1][1], False, False],
        [False, False, False, False, False, False],
        [False, False, False, False, False, False],
    ]

    #  The general case
    while currentIteration != iterations:
        
        currentGridSize = len(grid)

        #  Create the new grid
        newGrid = []
        for i in range(currentGridSize):
            row = []
            for j in range(currentGridSize):
                row.append(False)
                row.append(False)
            newGrid.append(row)
            newGrid.append(deepcopy(row))

        # For each grouping of four cells in the grid, apply logic to determine what they should be subdivided into
        for i in range(currentGridSize - 1):
            for j in range(currentGridSize - 1):

                # Extract the surrounding cells from the grid
                box = [
                    [grid[i][j], grid[i+1][j]],
                    [grid[i][j+1], grid[i+1][j+1]]
                ]

                gridIndex = determineGrid(box)
                center = deepcopy(random.choice(GRID_OPTIONS[gridIndex]))

                newGrid[i*2+1][j*2+1] = center[0][0]
                newGrid[i*2+2][j*2+1] = center[1][0]
                newGrid[i*2+1][j*2+2] = center[0][1]
                newGrid[i*2+2][j*2+2] = center[1][1]

        # print("GRID")
        # showGrid(grid)

        grid = newGrid

        currentIteration += 1

    print("GRID")
    showGrid(grid)

    grid = dilate(grid)
    grid = dilate(grid)
    grid = recede(grid)
    grid = recede(grid)

    print("GRID")
    showGrid(grid)

    #  The base case
    return grid

def showGrid(grid):

    if False:

        rowCount = 0
        for row in grid:

            for _ in range(2*len(grid) + 1):
                if rowCount % 2 == 1:
                    print("==", end = "")
                else:
                    print("  ", end = "")
            print()
            rowCount += 1

            print("|", end = "")
            colCount = 0
            for value in row:

                if colCount % 2 == 1:
                    print("|", end = "")
                else:
                    print(" ", end = "")

                colCount += 1

                if value:
                    print(u"\u2588\u2588", end = "")
                else:
                    print("  ", end = "")

                if colCount % 2 == 1:
                    print("|", end = "")
                else:
                    print(" ", end = "")

            print()

        for _ in range(2*len(grid) + 1):
            print("--", end = "")
        print()
    
    else:
        for row in grid:
            for value in row:
                if value:
                    print(u"\u2588\u2588", end = "")
                else:
                    print("  ", end = "")
            print()

generate(6)