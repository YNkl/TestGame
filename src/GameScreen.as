/**
 * Created by Юрий on 21.08.2016.
 */
package {
import starling.display.Quad;
import starling.display.Sprite;

public class GameScreen extends Sprite{
    private var background:Quad;

    public function GameScreen() {
        background = new Quad(800, 600, 0x000000);

        var field:Field = new Field(6,6);
        field.x = (background.width - field.width) / 2;
        field.y = (background.height - field.height) / 2;
        addChild(field);
    }
}
}
