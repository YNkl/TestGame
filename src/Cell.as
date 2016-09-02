/**
 * Created by Yna on 22.08.2016.
 */
package {
import starling.display.Quad;
import starling.display.Sprite;
import com.greensock.*;

public class Cell extends Sprite{
    public var background:Quad;
    private var typeOfCell:int;
    private var isPicked:Boolean = false;
    private var row:int;
    private var col:int;
    
    public function Cell(type:Number, row,col:int) {
        this.row = row;
        this.col = col;
        
        var bottomColor:uint = 0x1c1191; // blue
        var topColor:uint    = 0xffffff; // red
        switch (type){
            case 1 :
                background = new Quad(30,30, bottomColor);
                typeOfCell = 1;
                break;
            case 2 :
                background = new Quad(30,30, topColor);
                typeOfCell = 2;
                break;
        }
        useHandCursor = true;
        addChild(background);
    }

    public function selectCell(isSelected:Boolean):void{
        if(isSelected) {
            this.alpha = 0.2;
            isPicked = true;
        }
        else{
            this.alpha = 1;
            isPicked = false;
        }
    }
    
    public function setNewGridPosition(row,col:int){
        this.row = row;
        this.col = col;
    }
    
    public function get getCol(){
        return col;
    }

    public function get getRow(){
        return row;
    }
    
    public function getIsPicked():Boolean{
        return isPicked;
    }

    public function getType():int{
        return typeOfCell;
    }
}
}
