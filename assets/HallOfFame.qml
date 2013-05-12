import bb.cascades 1.0

BasePage
{
    showTitleBar: true
    
    contentContainer: Container {
        topPadding: 20
        rightPadding: 20
        leftPadding: 20

        Label {
            id: emptyLabel
            text: qsTr("There are no finished games yet!") + Retranslate.onLanguageChanged
            multiline: true
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            visible: false
        }

        Divider {
            bottomMargin: 0
            topMargin: 20
        }

        ListView {
            property int totalQuestions;
            
            dataModel: ArrayDataModel {
                id: theDataModel
            }

            onCreationCompleted: {
                var fame = persist.getValueFor("fame");
                
                if (fame.length > 0) {
                	theDataModel.append(fame);
                	totalQuestions = alpha.getAlphabets().length;
                } else {
                    emptyLabel.visible = true;
                }
            }

            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        imageSource: {
                            if (ListItemData.correct == ListItem.view.totalQuestions && ListItemData.incorrect == 0) {
                                return "asset:///images/ic_gold.png"
                            } else if (ListItemData.correct == ListItem.view.totalQuestions && ListItemData.incorrect > 0) {
                                return "asset:///images/ic_silver.png"
                            } else if (ListItemData.correct >= ListItem.view.totalQuestions-3 && ListItemData.incorrect >= 0) {
                                return "asset:///images/ic_bronze.png"
                            } else if (ListItemData.correct > 0) {
                                return "asset:///images/ic_like.png"
                            } else {
                                return "asset:///images/ic_dislike.png"
                            }
                        }
                        
                        title: qsTr("%1 correct, %2 incorrect").arg(ListItemData.correct).arg(ListItemData.incorrect);
                        status: qsTr("%1 s").arg(ListItemData.time);
                        description: Qt.formatDate(ListItemData.dateValue, Qt.SystemLocaleShortDate);
                    }
                }
            ]
            
            attachedObjects: [
                AlphabetUtil {
                    id: alpha
                }
            ]
        }
    }
}