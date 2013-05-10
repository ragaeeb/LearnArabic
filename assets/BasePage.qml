import bb.cascades 1.0

Page {
    property alias contentContainer: contentContainer.controls

    Container {
        attachedObjects: [
            ImagePaintDefinition {
                id: back
                imageSource: "asset:///images/background.png"
            }
        ]
        
		background: back.imagePaint
		horizontalAlignment: HorizontalAlignment.Fill
		verticalAlignment: VerticalAlignment.Fill

        ImageView {
            imageSource: "asset:///images/title.png"
            topMargin: 0
            leftMargin: 0
            rightMargin: 0
            bottomMargin: 0

            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top

            animations: [
                FadeTransition {
                    id: fadeInLogo
                    easingCurve: StockCurve.CubicIn
                    fromOpacity: 0
                    toOpacity: 1
                    duration: 1000
                }
            ]

            onCreationCompleted: {
                if (persist.getValueFor("animations") == 1) {
                    fadeInLogo.play()
                }
            }
        }

        ImageView {
            imageSource: "asset:///images/separator.png"
            topMargin: 0
            leftMargin: 0
            rightMargin: 0
            bottomMargin: 0
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
        }

        Container // This container is replaced
        {
            layout: DockLayout {
                
            }
            
            attachedObjects: [
            	ImagePaintDefinition {
            	    id: trans
            		imageSource: "asset:///images/transparent_bg.png"
                }
            ]
            
            id: contentContainer
            objectName: "contentContainer"
            background: trans.imagePaint
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
    }
}