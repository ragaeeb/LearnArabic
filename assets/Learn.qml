import bb.cascades 1.0
import bb.multimedia 1.0

BasePage
{
    actions: [
        ActionItem {
            imageSource: player.mediaState == MediaState.Started ? "asset:///images/ic_stop.png" : "asset:///images/ic_play.png"
            title: player.mediaState == MediaState.Started ? qsTr("Stop") : qsTr("Play")
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                console.log("CURRENT TRACK", player.currentTrack);
                
                if (player.currentTrack >= 0) {
                    player.currentTrack = -1;
                } else {
                    player.currentTrack = 0;
                    var target = [0];
                    
                    listView.triggered(target);
                    listView.scrollToItem(target, ScrollAnimation.Default);
                }

                console.log("CURRENT TRACK2", player.currentTrack);
            }
        }
    ]
    
    contentContainer: Container
    {
        ListView {
            id: listView
            
            attachedObjects: [
                AlphabetUtil {
                    id: alphaUtil
                },

                NowPlayingConnection {
                    id: nowPlaying
                    connectionName: "arabic"

                    onAcquired: {
                        player.reset()
                        player.play()
                    }

                    onPause: {
                        player.pause()
                    }

                    onRevoked: {
                        player.stop()
                    }
                },

                MediaPlayer {
                    property int currentTrack
                    id: player

                    onPlaybackCompleted: {
                        if (currentTrack >= 0) {
                            ++currentTrack;
                            
                            if ( currentTrack >= theDataModel.size() ) {
                                currentTrack = 0;
                            }
                            
                            var target = [currentTrack];
                            listView.triggered(target);
                            listView.scrollToItem(target, ScrollAnimation.Default);
                        }
                    }
                }
            ]

            dataModel: ArrayDataModel {
                id: theDataModel
            }

            onCreationCompleted: {
                theDataModel.append( alphaUtil.getAlphabets() )
                player.currentTrack = -1;
            }
            
            onTriggered: {
                if (player.currentTrack >= 0 && player.mediaStae == MediaState.Started) {
                    player.currentTrack = indexPath[0]
                } else {
                    var voice = persist.getValueFor("voice")

                    player.stop()
                    player.sourceUrl = "asset://audio/" + voice + "/" + indexPath + ".mp3"

                    if (nowPlaying.acquired) {
                        player.play();
                    } else {
                        nowPlaying.acquire()
                    }
                }
            }

            listItemComponents: [
                ListItemComponent {
                    Container {
                        property bool selected: ListItem.selected
                        property bool active: ListItem.active
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }

                        horizontalAlignment: HorizontalAlignment.Fill
                        background: selected || active ? Color.create("#ff6B4226") : undefined
                        rightPadding: 20; leftPadding: 20

                        Label {
                            text: ListItemData.glyph
                            textStyle.fontSize: FontSize.PointValue
                            textStyle.fontSizeValue: 60
                            textStyle.textAlign: TextAlign.Center
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Center
                            
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1
                            }
                        }

                        Label {
                            text: ListItemData.transliteration
                            textStyle.fontSize: FontSize.Small
                            textStyle.textAlign: TextAlign.Center
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Center
                        }
                    }
                }
            ]

            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
        }
    }
}