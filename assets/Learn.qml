import bb.cascades 1.0
import bb.multimedia 1.0
import com.canadainc.data 1.0

BasePage
{
    actions: [
        ActionItem {
            property bool timerActive: false
            id: playAction
            imageSource: timerActive || player.mediaState == MediaState.Started ? "asset:///images/ic_stop.png" : "asset:///images/ic_play.png"
            title: timerActive || player.mediaState == MediaState.Started ? qsTr("Stop") : qsTr("Play")
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                if (timerActive || player.mediaState == MediaState.Started) {
                    console.log("\n\n\nSTOPPING!!");
                    player.stopped = true;
                    timer.stop();
                    player.stop();
                    timerActive = false;
                } else {
                    player.stopped = false;
                    console.log("\n\n\nPLAYING!!");
                    listView.scrollToItem([ 0 ], ScrollAnimation.None);
                    player.currentTrack = 0;
                    player.playlist = [ 0, theDataModel.size()-1 ];
                    var voice = persist.getValueFor("voice")
                    player.sourceUrl = "asset://audio/" + voice + "/0.mp3"

                    if (nowPlaying.acquired) {
                        player.play();
                    } else {
                        nowPlaying.acquire()
                    }
                }
            }
        }
    ]
    
    contentContainer: Container
    {
        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            dataModel: ArrayDataModel {
                id: theDataModel
            }

            onCreationCompleted: {
                theDataModel.append( alphaUtil.getAlphabets() )
                player.currentTrack = -1;
            }
            
            onTriggered: {
                player.stopped = false;
                player.stop();
                player.currentTrack = indexPath[0];
                player.playlist = [player.currentTrack];
                var voice = persist.getValueFor("voice");
                player.sourceUrl = "asset://audio/" + voice + "/" + indexPath + ".mp3"

                if (nowPlaying.acquired) {
                    player.play();
                } else {
                    nowPlaying.acquire()
                }
            }
            
            onSelectionChanged: {
                playMultiAction.enabled = selectionList().length > 0;
            }

            multiSelectHandler {
                actions: [
                    ActionItem {
                        id: playMultiAction
                        title: qsTr("Play")
                        imageSource: "asset:///images/ic_play.png"

                        onTriggered: {
                            player.stopped = false;
                            var selected = listView.selectionList();
                            var first = selected[0];
                            var last = selected[selected.length-1];
                            player.stop();
                            var target = first[0];
                            player.currentTrack = target;
                            player.playlist = [ target, last[0] ];
                            var voice = persist.getValueFor("voice")
                            player.sourceUrl = "asset://audio/" + voice + "/" + target + ".mp3"

                            if (nowPlaying.acquired) {
                                listView.scrollToItem(first, ScrollAnimation.None);
                                player.play();
                            } else {
                                nowPlaying.acquire()
                            }
                        }
                    }
                ]

                status: qsTr("Select 1st & last range") + Retranslate.onLanguageChanged
            }

            multiSelectAction: MultiSelectActionItem {}

            listItemComponents: [
                ListItemComponent {
                    Container {
                        property bool selected: ListItem.selected
                        property bool active: ListItem.active
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }

                        horizontalAlignment: HorizontalAlignment.Fill
                        background: selected || active ? Color.create("#7f6B4226") : undefined
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
                        
                        contextActions: [
                            ActionSet {
                                title: ListItemData.glyph
                                subtitle: ListItemData.transliteration
                            }
                        ]
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
                        listView.scrollToItem([player.currentTrack], ScrollAnimation.None);
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

                    onPlaybackCompleted:
                    {
                        if (stopped) {
                            console.log("\n\n\nPLAYBACK COMPLETED BUT STOPPED PRESSED");
                            stopped = false;
                        } else {
                            ++ currentTrack;

                            if (currentTrack <= playlist[playlist.length - 1]) {
                                timer.animate = true;
                                playAction.timerActive = true;
                                timer.start(persist.getValueFor("delay"));
                            } else if (persist.getValueFor("repeat") == 1) { // reached the end of the list
                                currentTrack = playlist[0];
                                timer.animate = false;
                                playAction.timerActive = true;
                                timer.start(persist.getValueFor("delay"));
                            }
                        }
                    }
                },

                QTimer {
                    property bool animate: false
                    id: timer
                    singleShot: true

                    onTimeout: {
                        playAction.timerActive = false;
                        var voice = persist.getValueFor("voice");
                        player.sourceUrl = "asset://audio/" + voice + "/" + player.currentTrack + ".mp3";

                        listView.scrollToItem([player.currentTrack], animate ? ScrollAnimation.Default : ScrollAnimation.None);
                        player.play();
                    }
                }
            ]
        }
    }
}