import bb.cascades 1.0

BasePage
{
    showTitleBar: true

    contentContainer: ScrollView
    {  
    	horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
	    Container
	    {
	        leftPadding: 20
	        topPadding: 20
	        rightPadding: 20
	        bottomPadding: 20
	        
	        SettingPair {
	            title: qsTr("Animations")
	        	toggle.checked: persist.getValueFor("animations") == 1
	    
	            toggle.onCheckedChanged: {
	        		persist.saveValueFor("animations", checked ? 1 : 0)
	        		
	        		if (checked) {
	        		    infoText.text = qsTr("Controls will be animated whenever they are loaded.") + Retranslate.onLanguageChanged
	                } else {
	        		    infoText.text = qsTr("Controls will be snapped into position without animations.") + Retranslate.onLanguageChanged
	                }
	            }
	        }

            SettingPair {
                title: qsTr("Repeat")
                toggle.checked: persist.getValueFor("repeat") == 1

                toggle.onCheckedChanged: {
                    persist.saveValueFor("repeat", checked ? 1 : 0)

                    if (checked) {
                        infoText.text = qsTr("Recitations will be repeated from the beginning of the list once finished.") + Retranslate.onLanguageChanged
                    } else {
                        infoText.text = qsTr("Recitations will not be repeated when playback ends.") + Retranslate.onLanguageChanged
                    }
                }
            }

            DropDown {
                title: qsTr("Voice") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Fill

                Option {
                    text: qsTr("Female") + Retranslate.onLanguageChanged
                    description: qsTr("Female Voice") + Retranslate.onLanguageChanged
                    value: "female0"
                }

                Option {
                    id: primaryTransliteration
                    text: qsTr("Male") + Retranslate.onLanguageChanged
                    description: qsTr("Male Voice") + Retranslate.onLanguageChanged
                    value: "male0"
                }

                onCreationCompleted: {
                    var primary = persist.getValueFor("voice")

                    for (var i = 0; i < options.length; i ++) {
                        if (options[i].value == primary) {
                            options[i].selected = true
                            break;
                        }
                    }
                }

                onSelectedValueChanged: {
                    persist.saveValueFor("voice", selectedValue);
                }

                onSelectedOptionChanged: {
                    infoText.text = qsTr("Letter pronunciations will be recited with a %1 voice.").arg(selectedOption.text) + Retranslate.onLanguageChanged
                }
            }

            Container {
                topPadding: 20

                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Label {
                    text: qsTr("Delay")

                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                }

                Slider {
                    horizontalAlignment: HorizontalAlignment.Right
                    preferredWidth: 225
                    fromValue: 0
                    toValue: 5000
                    value: persist.getValueFor("delay")

                    onValueChanged: {
                        persist.saveValueFor("delay", value)
                        infoText.text = qsTr("There will be a delay of %1 seconds between pronunciations.").arg(value/1000);
                    }
                }
            }

            Label {
	            id: infoText
	            multiline: true
	            textStyle.fontSize: FontSize.XXSmall
	            textStyle.textAlign: TextAlign.Center
	            verticalAlignment: VerticalAlignment.Bottom
	            horizontalAlignment: HorizontalAlignment.Center
	        }
	    }
    }
}