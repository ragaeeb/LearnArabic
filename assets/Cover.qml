import bb.cascades 1.0

Container
{
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "asset:///images/background.png"
        }
    ]
    
    background: back.imagePaint
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    
    layout: DockLayout {}

    ImageView {
        imageSource: "asset:///images/logo.png"
        topMargin: 0
        leftMargin: 0
        rightMargin: 0
        bottomMargin: 0
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
    }
}