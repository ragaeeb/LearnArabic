import bb.cascades 1.0
import com.canadainc.data 1.0

Container
{
    property variant alphabets
    property int currentIndex;
    
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///images/background.png"
        },
        
        AlphabetUtil {
            id: alphaUtil
            
            onCreationCompleted: {
                alphabets = alphaUtil.getAlphabets();
                currentIndex = 0;
                updateCover();
                timer.start();
            }
        },

        QTimer {
            id: timer
            singleShot: false
            interval: 30000

            onTimeout: {
                ++currentIndex;
                
                if (currentIndex >= alphabets.length) {
                    currentIndex = 0;
                }
                
                updateCover();
            }
        }
    ]
    
    function updateCover() {
        glyphLabel.text = alphabets[currentIndex].glyph;
    }
    
    background: back.imagePaint
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    
    layout: DockLayout {}

    Label {
        id: glyphLabel
        textStyle.fontSize: FontSize.PointValue
        textStyle.fontSizeValue: 30
        textStyle.textAlign: TextAlign.Center
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Center
    }
}