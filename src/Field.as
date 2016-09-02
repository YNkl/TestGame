/**
 * Created by Yna on 22.08.2016.
 */
package {

import com.greensock.TweenLite;

import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Field extends Sprite{
    private var cells:Array = new Array();
    private var firstCell:Cell = null;
    private var secondCell:Cell = null;
    private var deletedCells:Array = new Array();

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
        var isSwapped:Boolean = false;

        if((firstCell.getCol + 1 == secondCell.getCol || firstCell.getCol - 1 == secondCell.getCol) && firstCell.getRow == secondCell.getRow) {
            TweenLite.to(firstCell, 0.5, {x: secondCell.x, y: secondCell.y});
            cells[secondCell.getRow][secondCell.getCol] = firstCell;
            firstCell.setNewGridPosition(secondCell.getRow, secondCell.getCol);

            TweenLite.to(secondCell, 0.5, {x: tempX, y: tempY});
            cells[tempRow][tempCol] = secondCell;
            secondCell.setNewGridPosition(tempRow, tempCol);
            isSwapped = true;
        }
        else if((firstCell.getRow + 1 == secondCell.getRow || firstCell.getRow - 1 == secondCell.getRow) && firstCell.getCol == secondCell.getCol) {
            TweenLite.to(firstCell, 0.5, {x: secondCell.x, y: secondCell.y});
            cells[secondCell.getRow][secondCell.getCol] = firstCell;
            firstCell.setNewGridPosition(secondCell.getRow, secondCell.getCol);

            TweenLite.to(secondCell, 0.5, {x: tempX, y: tempY});
            cells[tempRow][tempCol] = secondCell;
            secondCell.setNewGridPosition(tempRow, tempCol);
            isSwapped = true;
        }

        if(isSwapped) {
            deletedCells.push(cells[firstCell.getRow][firstCell.getCol]);
           // deletedCells.concat(findLines(firstCell));
            //trace(.length);
            var a:Array = findLines(firstCell);
            deletedCells = deletedCells.concat(findLines(firstCell), findColumns(firstCell));
            trace(deletedCells.length);
            for(var i:Number = 0; i < deletedCells.length; i++){
                trace(deletedCells[i]);
            }
            //if(findLines(firstCell).length >= 1){
              //  deletedCells.concat(findLines(firstCell));
            //}
            //deletedCells.concat(findColumns(firstCell));

            for (var j:Number = 0; j < deletedCells.length; j++) {
                deleteCell(deletedCells[j]);
                //trace(deletedCells[j]);
            }
            //findLines(secondCell);
        }
        //

        this.firstCell = null;
        this.secondCell = null;
    }

    private function findColumns(currCell:Cell):Array{
        var tempArr:Array = new Array();
        var findLeft:Boolean = true;
        var findRight:Boolean = true;

        for(var i:int = 1; i < 6; i++) {
            if(findLeft == false && findRight == false){
                break;
            }
            if (currCell.getRow + i < 6 && currCell.getType() == cells[currCell.getRow + i][currCell.getCol].getType() && findRight) {
                tempArr.push(cells[currCell.getRow + i][currCell.getCol]);
            }
            else{
                findRight = false;
            }

            if(cells[currCell.getRow - i] != null) {
                if (cells[currCell.getRow - i][currCell.getCol] != null && currCell.getType() == cells[currCell.getRow - i][currCell.getCol].getType() && findLeft) {
                    tempArr.push(cells[currCell.getRow - i][currCell.getCol]);
                }
                else{
                    findLeft = false;
                }
            }
            else{
                findLeft = false;
            }

        }

        /*if(tempArr.length >= 2) {
            tempArr.push(cells[currCell.getRow][currCell.getCol]);
             for (var j:Number = 0; j < tempArr.length; j++) {
                deleteCell(tempArr[j]);
            }

        }*/
        return tempArr;
    }

    private function findLines(currCell:Cell):Array{
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
        /*if(tempArr.length >= 2) {
            tempArr.push(cells[currCell.getRow][currCell.getCol]);
             for (var j:Number = 0; j < 1; j++) {
                deleteCell(tempArr[j]);
            }

        }*/
        return tempArr;
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

                cells[deletedCell.getRow - i + 1][deletedCell.getCol] = cells[deletedCell.getRow - i][deletedCell.getCol];
                if(cells[deletedCell.getRow - i + 1][deletedCell.getCol] != null) {
                    cells[deletedCell.getRow - i + 1][deletedCell.getCol].setNewGridPosition(deletedCell.getRow - i + 1, deletedCell.getCol);
                    TweenLite.to(cells[deletedCell.getRow - i][deletedCell.getCol], 0.5, {y: currRow * 40 - ((i - 1) * 40)});
                }
                if(deletedCell.getRow - i == 0){
                    cells[deletedCell.getRow - i][deletedCell.getCol] = null;
                }
            }
            else{
                break;
            }
        }
    }
}
}
