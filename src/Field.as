/**
 * Created by Yna on 22.08.2016.
 */
package {

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Field extends Sprite{
    private var cells:Array = new Array();
    private var firstCell:Cell = null;
    private var secondCell:Cell = null;

    public function Field(rows:Number, columns:Number) {
        for (var i:int = 0; i < rows; i++){
            cells.push(new Array());
        }
        makeField(rows, columns);
    }

    private function makeField(rows:Number, columns:Number):void{
        for (var i:Number = 0; i < rows; i++) {
            for (var j:Number = 0; j < columns; j++) {
                cells[i][j] = new Cell(Math.round(Math.random() * 1) + 1, i, j);
                cells[i][j].x = j * (cells[i][j].width + 10);
                cells[i][j].y = i * (cells[i][j].height + 10);
                cells[i][j].addEventListener(TouchEvent.TOUCH, clickCell);
                addChild(cells[i][j]);
            }
        }
    }

    private function clickCell(e:TouchEvent):void{
        var cell = e.currentTarget;

        if(e.getTouch(this,TouchPhase.BEGAN)) {
            if (firstCell == null) {
                firstCell = cell as Cell;
                firstCell.selectCell(true);
            }
            else if(firstCell == cell){
                firstCell.selectCell(false);
                firstCell = null;
            }
            else {
                secondCell = cell as Cell;
                firstCell.selectCell(false);
                swapCells(firstCell, secondCell);
            }
        }
    }

    private function swapCells(firstCell, secondCell:Cell):void{
        var tempX = firstCell.x;
        var tempY = firstCell.y;
        var tempRow:int = firstCell.getRow;
        var tempCol:int = firstCell.getCol;

        if((firstCell.getCol + 1 == secondCell.getCol || firstCell.getCol - 1 == secondCell.getCol) && firstCell.getRow == secondCell.getRow) {
            firstCell.x = secondCell.x;
            firstCell.y = secondCell.y;
            cells[secondCell.getRow][secondCell.getCol] = firstCell;
            firstCell.setNewGridPosition(secondCell.getRow, secondCell.getCol);

            secondCell.x = tempX;
            secondCell.y = tempY;
            cells[tempRow][tempCol] = secondCell;
            secondCell.setNewGridPosition(tempRow, tempCol);
        }
        else if((firstCell.getRow + 1 == secondCell.getRow || firstCell.getRow - 1 == secondCell.getRow) && firstCell.getCol == secondCell.getCol) {
            firstCell.x = secondCell.x;
            firstCell.y = secondCell.y;
            cells[secondCell.getRow][secondCell.getCol] = firstCell;
            firstCell.setNewGridPosition(secondCell.getRow, secondCell.getCol);

            secondCell.x = tempX;
            secondCell.y = tempY;
            cells[tempRow][tempCol] = secondCell;
            secondCell.setNewGridPosition(tempRow, tempCol);
        }
        findLines(secondCell);
        findLines(firstCell);
        this.firstCell = null;
        this.secondCell = null;
    }

    private function findLines(currCell:Cell):void{
        var tempArr:Array = new Array();
        var findLeft:Boolean = true;
        var findRight:Boolean = true;

        for(var i:int = 0; i < 6; i++) {
            if(findLeft == false && findRight == false){
                break;
            }
            if (cells[currCell.getRow][currCell.getCol + i] != null && currCell.getType() == cells[currCell.getRow][currCell.getCol + i].getType() && findRight) {
                tempArr.push(cells[currCell.getRow][currCell.getCol + i]);
            }
            else{
                findRight = false;
            }
            if (cells[currCell.getRow][currCell.getCol - i] != null && currCell.getType() == cells[currCell.getRow][currCell.getCol - i].getType() && findLeft) {
                tempArr.push(cells[currCell.getRow][currCell.getCol - i]);
            }
            else{
                findLeft = false;
            }

        }
        if(tempArr.length > 3) {
            for (var j:Number = 0; j < tempArr.length; j++) {
                tempArr[j].alpha = 0;
                moveCellsDown(tempArr);
            }
        }
    }

    private function moveCellsDown(deletedCells:Array):void{
        for(var i:Number = 0; i < deletedCells.length; i++){
            var j:int = 1;
            var row:int = deletedCells[i].getRow;
            var col:int = deletedCells[i].getCol;
            while(true) {
                if (row - j >= 0) {
                    //cells
                    //trace(cells[row - j + 1][col].y);
                    var curRow = row - j + 1;
                    trace(curRow);
                    cells[row - j][col].y = cells[curRow][col].y; //изменить ячейку!!!!!!!!!!!!!
                    addChild(cells[row - j][col]);
                    //cells[row - j][col].setNewGridPosition(row - j + 1, col);
                    cells[curRow][col] = cells[row - j][col];
                    //cells[deletedCells[i].getRow - row][deletedCells[i].getCol].setNewGridPosition(deletedCells[i].getRow - row + 1,deletedCells[i].getCol);
                    //cells[deletedCells[i].getRow - row][deletedCells[i].getCol] = null;
                    j++;
                }
                else
                    break;
            }
        }
    }
}
}
