import bb.cascades 1.0

NavigationPane {
    id: navigationPane

    attachedObjects: [
        ComponentDefinition {
            id: definition
        }
    ]

    onPopTransitionEnded: {
        page.destroy();
    }

    Menu.definition: MenuDefinition {
        id: menu

        settingsAction: SettingsActionItem {
            property Page settingsPage

            onTriggered: {
                if (! settingsPage) {
                    definition.source = "SettingsPage.qml"
                    settingsPage = definition.createObject()
                }

                navigationPane.push(settingsPage);
            }
        }

        helpAction: HelpActionItem {
            property Page helpPage

            onTriggered: {
                if (! helpPage) {
                    definition.source = "HelpPage.qml"
                    helpPage = definition.createObject();
                }

                navigationPane.push(helpPage);
            }
        }
    }

    BasePage {
        id: mainPage
        showTitleBar: true

        contentContainer: Container
        {
            topPadding: 20; rightPadding: 20; leftPadding: 20
            
            Label {
                text: qsTr("Welcome to Learn Arabic. This app was developed to make it easy for beginners to learn the Arabic alphabet. From below, choose what you want.") + Retranslate.onLanguageChanged
                multiline: true
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
            }
            
            Divider {
                bottomMargin: 0; topMargin: 20
            }
            
            ListView {
                dataModel: ArrayDataModel {
                    id: theDataModel
                }
                
                onCreationCompleted: {
                    theDataModel.append({
                            'title': qsTr("Learn"),
                            'description': qsTr("Learn the Arabic alphabet"),
                            'imageSource': "asset:///images/ic_learn.png"
                        });
                    theDataModel.append({
                            'title': qsTr("Easy Test"),
                            'description': qsTr("For the inner child in you!"),
                            'imageSource': "asset:///images/ic_test_easy.png"
                        });

                    theDataModel.append({
                            'title': qsTr("Medium Test"),
                            'description': qsTr("Test your knowledge!"),
                            'imageSource': "asset:///images/ic_test_medium.png"
                        });

                    theDataModel.append({
                            'title': qsTr("Hard Test"),
                            'description': qsTr("If you can handle it!"),
                            'imageSource': "asset:///images/ic_test_hard.png"
                        });

                    theDataModel.append({
                            'title': qsTr("Hall of Fame"),
                            'description': qsTr("See your past accomplishments"),
                            'imageSource': "asset:///images/ic_gold.png"
                        });
                }
                
                listItemComponents: [
                    ListItemComponent {
                        StandardListItem {
                            imageSource: ListItemData.imageSource;
                            title: ListItemData.title;
                            description: ListItemData.description
                        }
                    }
                ]
                
                onTriggered: {
                    if (indexPath == 0) {
                        definition.source = "Learn.qml"
                    } else if (indexPath == 1 || indexPath == 2 || indexPath == 3){
                        definition.source = "Test.qml"
                    } else {
                        definition.source = "HallOfFame.qml"
                    }

                    var page = definition.createObject();
                    
                    navigationPane.push(page);

                    if (indexPath == 1) {
                        page.clockTime = 30;
                        page.initialHealth = 20;
                        page.start(false);
                    } else if (indexPath == 2) {
                        page.clockTime = 20;
                        page.initialHealth = 10;
                        page.start(true);
                    } else if (indexPath == 3) {
                        page.clockTime = 10;
                        page.initialHealth = 3;
                        page.start(true);
                    }
                }
            }
        }
    }
}