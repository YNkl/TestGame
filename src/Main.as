package {

import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.Event;

import starling.core.Starling;
import starling.events.ResizeEvent;

[SWF(width = "800", height = "600", frameRate = "60", backgroundColor = "#aaaaaa")]

public class Main extends Sprite {
    private var starling:Starling;

    public function Main() {
        stage
        stage.scaleMode = StageScaleMode.NO_SCALE;
        starling = new Starling(GameScreen, stage);
        starling.start();
        stage.addEventListener(ResizeEvent.RESIZE, resizeStage);
    }

    private function resizeStage(e:flash.events.Event){
        if (starling) {
            starling.viewPort.x = (stage.stageWidth - starling.viewPort.width) / 2;
            starling.viewPort.y = (stage.stageHeight - starling.viewPort.height) / 2;
            trace("resized");
        }
    }
}
}
