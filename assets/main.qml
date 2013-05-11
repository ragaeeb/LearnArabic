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
                bottomMargin: 0;
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
                            'title': qsTr("Test"),
                            'description': qsTr("Test your knowledge!"),
                            'imageSource': "asset:///images/ic_test.png"
                        });
                }
                
                listItemComponents: [
                    ListItemComponent {
                        StandardListItem {
                            imageSource: ListItemData.imageSource;
                            title: ListItemData.title;
                        }
                    }
                ]
                
                onTriggered: {
                    if (indexPath == 0) {
                        definition.source = "Learn.qml"
                    } else {
                        definition.source = "Test.qml"
                    }

                    var page = definition.createObject()
                    navigationPane.push(page)
                }
            }
        }
    }
}