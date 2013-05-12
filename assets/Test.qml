import bb.cascades 1.0
import bb.multimedia 1.0
import com.canadainc.data 1.0

BasePage {
    property bool started: false;
    property variant shuffledAudio;
    property int currentIndex;
    property int clockTime;
    property int initialHealth;
    property int answersRight: 0
    property int answersWrong: 0
    property int totalTime: 0

    paneProperties: NavigationPaneProperties {
        property variant navPane: navigationPane
        id: properties
    }
    
    function start(shuffleAlphabet)
    {
        var shuffledUI = shuffleAlphabet ? alphaUtil.getShuffledAlphabets() : alphaUtil.getAlphabets();
        shuffledAudio = alphaUtil.getShuffledAlphabets();

        theDataModel.append(shuffledUI);
        
        lives.toValue = initialHealth;
        lives.health = initialHealth;

        clockLabel.time = 3;
        started = false;
        timer.start();
    }
    
    function finish(message)
    {
        totalTime += clockTime - clockLabel.time;
        
        var fame = persist.getValueFor("fame");
        fame.unshift( {'dateValue': new Date(), 'correct': answersRight, 'incorrect': answersWrong, 'time': totalTime} );
        persist.saveValueFor("fame", fame);
        
        persist.showToast(qsTr("%1\n\nRight answers: %2\nWrong answers: %3\nTotal time: %4 seconds").arg(message).arg(answersRight).arg(answersWrong).arg(totalTime));
        properties.navPane.pop();
    }

    contentContainer: Container
    {
        horizontalAlignment: HorizontalAlignment.Fill
        topPadding: 6; leftPadding: 6; rightPadding: 6; bottomPadding: 6;
        
        Container {
            id: clock
            layout: DockLayout {}
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top

            ActivityIndicator {
                preferredWidth: 250
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                running: true
            }
            
            Label {
                property int time
                id: clockLabel
                text: time
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
            
            attachedObjects: [
                QTimer {
                    id: timer
                    singleShot: false
                    interval: 1000

                    onTimeout: {
                        clockLabel.time = clockLabel.time-1;
                        sound.sound = SystemSound.InputKeypress;
                        sound.play();
                        
                        if (clockLabel.time == -1)
                        {
                            if (!started)
                            {
                                listView.visible = true;
                                clockLabel.time = clockTime;
                                currentIndex = 0;
                                started = true;
                                var voice = persist.getValueFor("voice");
                                player.sourceUrl = "asset://audio/" + voice + "/"+ shuffledAudio[currentIndex].index +".mp3";
                                hintButton.text = shuffledAudio[currentIndex].transliteration;

                                if (nowPlaying.acquired) {
                                    player.play();
                                } else {
                                    nowPlaying.acquire()
                                }
                            } else { // user ran out of time, game over!
                                finish( qsTr("You ran out of time, game over!") );
                            }
                        }
                    }
                },
                
                QTimer {
                    id: silentTimer
                    singleShot: true
                    
                    onTimeout: {
                        for (var i = 0; i < theDataModel.size(); i++) {
                            var data = theDataModel.value(i);
                            data.correct = undefined;
                            
                            theDataModel.replace(i,data);
                        }

                        listView.scrollToItem([ 0 ], ScrollAnimation.Default);
                        clockLabel.time = clockTime;
                        ++currentIndex;
                        
                        if ( currentIndex >= shuffledAudio.length ) {
                            finish( qsTr("Test successfully completed! Good job!") );
                        } else {
                            listView.enabled = true;
                            var voice = persist.getValueFor("voice");
                            player.sourceUrl = "asset://audio/" + voice + "/" + shuffledAudio[currentIndex].index + ".mp3"
                            player.play();
                            timer.start();
                            hintButton.text = shuffledAudio[currentIndex].transliteration;
                        }
                    }
                }
            ]
        }
        
        ProgressIndicator {
            property int health
            id: lives
            fromValue: 0;
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
            value: health
            visible: started;
            state: ProgressIndicatorState.Progress
            
            onHealthChanged: {
                if (health < 0) {
                    finish(qsTr("Game over, too many wrong answers!"));
                } else if (health < Math.ceil(initialHealth/3) ) {
                    state = ProgressIndicatorState.Error;
                } else if (health < Math.ceil(initialHealth / 1.5) ) {
                    state = ProgressIndicatorState.Pause;
                }
            }
        }
        
        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            visible: false
            
            layout: GridListLayout {
                columnCount: 4
            }

            dataModel: ArrayDataModel {
                id: theDataModel
            }
            
            leadingVisual: Container {
                horizontalAlignment: HorizontalAlignment.Fill
                
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Button {
                    id: hintButton
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }

                    onClicked: {
                        player.play();
                    }
                }
            }

            onTriggered: {
                var data = dataModel.data(indexPath);

                if (data.index == shuffledAudio[currentIndex].index) {
                    sound.sound = SystemSound.VideoCallOutgoingEvent;
                    data["correct"] = 1;
                    enabled = false;
                    ++answersRight;
                    timer.stop();
                    totalTime += clockTime-clockLabel.time;
                    silentTimer.start(2000);
                } else {
                    sound.sound = SystemSound.RecordingStopEvent;
                    data["correct"] = 2;
                    ++ answersWrong;
                    lives.health = lives.health-1;
                }
                
                theDataModel.replace(indexPath,data);
                sound.play();
            }

            listItemComponents: [
                ListItemComponent {
                    Container {
                        property bool active: ListItem.active
                        property int correct: ListItemData.correct ? ListItemData.correct : 0
                        id: rootItem
                        layout: DockLayout {}

                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        background: active ? Color.create("#7f6B4226") : undefined
                        
                        onCorrectChanged: {
                            if (correct == 1) {
                                background = Color.DarkGreen
                            } else if (correct == 2) {
                                background = Color.DarkRed
                            } else if (active) {
                                background = Color.create("#7f6B4226");
                            } else {
                                background = undefined;
                            }
                        }
                        
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

                SystemSound {
                    id: sound
                }
            ]
        }
    }
}
