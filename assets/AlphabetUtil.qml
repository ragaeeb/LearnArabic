import bb.cascades 1.0

QtObject {
    function getAlphabets()
    {
        var theDataModel = [];
        
        theDataModel.push({
                'glyph': "أ",
                'transliteration': "'Alif"
            });

        theDataModel.push({
                'glyph': "ب",
                'transliteration': "Baa'"
            });

        theDataModel.push({
                'glyph': "ت",
                'transliteration': "Taa'"
            });

        theDataModel.push({
                'glyph': "ث",
                'transliteration': "Thaa'"
            });

        theDataModel.push({
                'glyph': "ج",
                'transliteration': "Jeem"
            });

        theDataModel.push({
                'glyph': "ح",
                'transliteration': "Haa'"
            });

        theDataModel.push({
                'glyph': "خ",
                'transliteration': "Khaa'"
            });

        theDataModel.push({
                'glyph': "د",
                'transliteration': "Daal"
            });

        theDataModel.push({
                'glyph': "ذ",
                'transliteration': "Thaal"
            });

        theDataModel.push({
                'glyph': "ر",
                'transliteration': "Raa'"
            });

        theDataModel.push({
                'glyph': "ز",
                'transliteration': "Zaay"
            });

        theDataModel.push({
                'glyph': "س",
                'transliteration': "Seen"
            });

        theDataModel.push({
                'glyph': "ش",
                'transliteration': "Sheen"
            });

        theDataModel.push({
                'glyph': "ص",
                'transliteration': "Saad"
            });

        theDataModel.push({
                'glyph': "ض",
                'transliteration': "Daad"
            });

        theDataModel.push({
                'glyph': "ط",
                'transliteration': "Taa'"
            });

        theDataModel.push({
                'glyph': "ظ",
                'transliteration': "Dhaa'"
            });

        theDataModel.push({
                'glyph': "ع",
                'transliteration': "'Ayn"
            });

        theDataModel.push({
                'glyph': "غ",
                'transliteration': "'Ghyn"
            });

        theDataModel.push({
                'glyph': "ف",
                'transliteration': "Faa'"
            });

        theDataModel.push({
                'glyph': "ق",
                'transliteration': "Qaaf"
            });

        theDataModel.push({
                'glyph': "ك",
                'transliteration': "Kaaf"
            });

        theDataModel.push({
                'glyph': "ل",
                'transliteration': "Laam"
            });

        theDataModel.push({
                'glyph': "م",
                'transliteration': "Meem"
            });

        theDataModel.push({
                'glyph': "ن",
                'transliteration': "Noon"
            });

        theDataModel.push({
                'glyph': "ه",
                'transliteration': "Haa'"
            });

        theDataModel.push({
                'glyph': "و",
                'transliteration': "Wow"
            });

        theDataModel.push({
                'glyph': "ي",
                'transliteration': "Yaa'"
            });
            
        for (var i = 0; i < theDataModel.length; i++) {
            var current = theDataModel[i];
            current["index"] = i;
            theDataModel[i] = current;
        }
            
        return theDataModel;
    }
}