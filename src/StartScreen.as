/**
 * Created by Юрий on 21.08.2016.
 */
package {
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

public class StartScreen extends Sprite{
    public function StartScreen() {
        var quad:Quad = new Quad(200, 200, Color.RED);
        quad.x = 100;
        quad.y = 50;
        addChild(quad);
    }
}
}
