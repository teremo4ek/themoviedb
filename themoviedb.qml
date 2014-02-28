import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import "main.js" as Main

Rectangle {
    id: main
    width: 360
    height: 360

    color: 'skyblue'

    property string api_key : "4ffeeb5b2756dd0f7ac5d6d1da1faf7e"

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded

    property var films;

    Row {
        id: row1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 5


        spacing: 5

        Rectangle {
            id: searchstr

            height: 25
            width: 200

            color: "#ffffff"
            border.width: 3

            TextInput {
                id: search_txt

                text: qsTr("Thor: The Dark World")
                anchors.fill: parent
                anchors.margins: 3
                font.pixelSize: 16

                onAccepted: searchFunc()
            }
        }

        Button {
            id: btnok
            height: 25
            width: 20
            text: qsTr("OK")
            onClicked: searchFunc()
        }

    }

    ListView {
        id: mainListView

        anchors.margins: 10

        anchors.top: row1.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        //model: films
        spacing: 10

        model: ListModel { id: finalModel }

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
        }

        remove: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 400 }
            NumberAnimation { property: "scale"; from: 1; to: 0; duration: 400 }
        }

        delegate: FilmDelegate{}

        function add(obj) {
            //model.insert(0, obj)
            model.append(obj)
        }

        function clear() {
            interactive: true
            model.clear()
        }
    }


    function encodePhrase(x) { return encodeURIComponent(x); }

    function searchFunc()
    {
        mainListView.clear();
        console.log("search movies -- " + search_txt.text);

        var strget = "https://api.themoviedb.org/3/search/movie?api_key=" + api_key +
                "&query='" + encodePhrase(search_txt.text)+ "'";
        console.log("get  -- " + strget);

        var req = new XMLHttpRequest;
        req.open("GET", strget);

        req.onreadystatechange = function() {
            status = req.readyState;
            //console.log("onreadystatechange  -- " + status);

            if (status === XMLHttpRequest.DONE)
            {
                if (req.status && req.status === 200)
                {
                    //console.log("XMLHttpRequest.DONE txt --   " + req.responseText );
                    var objectArray = JSON.parse(req.responseText);

                    if (objectArray.errors !== undefined)
                    {
                        console.log("Error fetching tweets: " + objectArray.errors[0].message)
                    }
                    else
                    {
                        //main.films = objectArray.results

                        for (var indx in objectArray.results)
                        {
                            var jsonObject = objectArray.results[indx];

                            /*mainListView.add({ "poster_path": jsonObject["poster_path"],
                                               "original_title": jsonObject["original_title"]
                                             });*/

                            mainListView.add(jsonObject);
                            for(var key in jsonObject)
                            {
                                //console.log(key," = ", jsonObject[key]);
                            }
                        }
                    }
                }
                else
                {
                    console.log("HTTP:", req.status, req.statusText)
                }
            }
        }
        req.send();
    }

}

