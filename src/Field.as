/**
 * Created by Yna on 22.08.2016.
 */
package {

import com.greensock.TweenLite;
import com.greensock.TweenLite;
import com.greensock.TweenLite;

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
            TweenLite.to(firstCell, 1, {x: secondCell.x, y: secondCell.y});
            cells[secondCell.getRow][secondCell.getCol] = firstCell;
            firstCell.setNewGridPosition(secondCell.getRow, secondCell.getCol);

            TweenLite.to(secondCell, 1, {x: tempX, y: tempY});
            cells[tempRow][tempCol] = secondCell;
            secondCell.setNewGridPosition(tempRow, tempCol);
        }
        else if((firstCell.getRow + 1 == secondCell.getRow || firstCell.getRow - 1 == secondCell.getRow) && firstCell.getCol == secondCell.getCol) {
            TweenLite.to(firstCell, 1, {x: secondCell.x, y: secondCell.y});
            cells[secondCell.getRow][secondCell.getCol] = firstCell;
            firstCell.setNewGridPosition(secondCell.getRow, secondCell.getCol);

            TweenLite.to(secondCell, 1, {x: tempX, y: tempY});
            cells[tempRow][tempCol] = secondCell;
            secondCell.setNewGridPosition(tempRow, tempCol);
        }

        trace(firstCell.getRow, firstCell.getCol);
        trace(secondCell.getRow, secondCell.getCol);
        //findLines(secondCell);
        findLines(firstCell);
        this.firstCell = null;
        this.secondCell = null;
    }

    private function findLines(currCell:Cell):void{
        var tempArr:Array = new Array();
        var findLeft:Boolean = true;
        var findRight:Boolean = true;

        for(var i:int = 1; i < 6; i++) {
            if(findLeft == false && findRight == false){
                break;
            }
            if (cells[currCell.getRow][currCell.getCol + i] != null && currCell.getType() == cells[currCell.getRow][currCell.getCol + i].getType() && findRight) {
                tempArr.push(cells[currCell.getRow][currCell.getCol + i]);
            }
            else{
                findRight = false;
            }
            //удалить дублирующие
            if (cells[currCell.getRow][currCell.getCol - i] != null && currCell.getType() == cells[currCell.getRow][currCell.getCol - i].getType() && findLeft) {
                tempArr.push(cells[currCell.getRow][currCell.getCol - i]);
            }
            else{
                findLeft = false;
            }

        }
        if(tempArr.length >= 2) {
            tempArr.push(cells[currCell.getRow][currCell.getCol]);
            for (var j:Number = 0; j < tempArr.length; j++) {
                deleteCell(tempArr[j]);
            }
        }
    }

    private function deleteCell(deletedCell:Cell):void{
        removeChild(deletedCell);
        cells[deletedCell.getRow][deletedCell.getCol] = null;
        moveCellsDown(deletedCell);
    }

    private function moveCellsDown(deletedCell:Cell):void{
        var currRow:Number = deletedCell.getRow;

        for(var i:int = 1; i < 6; i++) {
            if(deletedCell.getRow - i >= 0) {
                //занулить то откуда уезжает
                TweenLite.to(cells[deletedCell.getRow - i][deletedCell.getCol], 0.5, {y: currRow * 40 - ((i - 1) * 40)});
                cells[deletedCell.getRow - i + 1][deletedCell.getCol] = cells[deletedCell.getRow - i][deletedCell.getCol];
                cells[deletedCell.getRow - i + 1][deletedCell.getCol].setNewGridPosition(deletedCell.getRow - i + 1, deletedCell.getCol);
            }
            else{
                break;
            }
        }
    }
}
}
