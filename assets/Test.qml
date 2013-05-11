import bb.cascades 1.0
import bb.multimedia 1.0
import com.canadainc.data 1.0

BasePage {
    contentContainer: Container
    {
        topPadding: 6; leftPadding: 6; rightPadding: 6; bottomPadding: 6;
        
        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            layout: GridListLayout {
                columnCount: 4
            }

            dataModel: ArrayDataModel {
                id: theDataModel
            }

            onCreationCompleted: {
                theDataModel.append(alphaUtil.getAlphabets())
            }

            listItemComponents: [
                ListItemComponent {
                    Container {
                        property bool active: ListItem.active
                        id: rootItem
                        layout: DockLayout {}

                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        background: active ? Color.create("#7f6B4226") : undefined
                        
                        ImageView {
                            imageSource: "asset:///images/transparent_bg.png"
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Fill
                            opacity: 0.5
                        }

                        Label {
                            text: ListItemData.glyph
                            textStyle.fontSize: FontSize.XXLarge
                            textStyle.textAlign: TextAlign.Center
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Center
                        }
                    }
                }
            ]

            attachedObjects: [
                AlphabetUtil {
                    id: alphaUtil
                },

                NowPlayingConnection {
                    id: nowPlaying
                    connectionName: "arabic"

                    onAcquired: {
                        player.reset();
                        player.play();
                    }

                    onPause: {
                        player.pause()
                    }

                    onRevoked: {
                        player.stop()
                    }
                },

                MediaPlayer {
                    property variant playlist
                    property int currentTrack
                    property bool stopped: false
                    id: player

                    onPlaybackCompleted: {
                    }
                },

                QTimer {
                    id: timer
                    singleShot: true

                    onTimeout: {
                    }
                }
            ]
        }
    }
}
