import QtQuick 2.0

Rectangle {
    id: recipe
    property real detailsOpacity : 0

    width: mainListView.width
    height: 100
    anchors.horizontalCenter: parent.horizontalCenter
    color: 'ivory'
    border {
        color: 'lightgray'
        width: 2
    }
    radius: 10

    Row {
        anchors.margins: 10
        anchors.fill: parent
        spacing: 10

        Image {
            id: image

            height: parent.height
            fillMode: Image.PreserveAspectFit
            source: "http://image.tmdb.org/t/p/w92%1".arg(model.poster_path)
        }

        Column{

            width: recipe.width - image.width - 20
            anchors.top: parent.top
            height: image.height
            spacing: 5

            Text {
                id:originalTitle
                width: parent.width - image.width - parent.spacing
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                renderType: Text.NativeRendering
                text: model.original_title
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: recipe.state = 'Details';
    }

    states: State {
        name: "Details"

        PropertyChanges { target: recipe; color: "white" }
        //PropertyChanges { target: recipeImage; width: 130; height: 130 } // Make picture bigger
        PropertyChanges { target: recipe; detailsOpacity: 1; x: 0 } // Make details visible
        PropertyChanges { target: recipe; height: mainListView.height } // Fill the entire list area with the detailed view

        // Move the list so that this item is at the top.
        PropertyChanges { target: recipe.ListView.view; explicit: true; contentY: recipe.y }

        // Disallow flicking while we're in detailed view
        //PropertyChanges { target: recipe.ListView.view; interactive: false }
    }


    transitions: Transition {
        // Make the state changes smooth
        ParallelAnimation {
            ColorAnimation { property: "color"; duration: 500 }
            NumberAnimation { duration: 300; properties: "detailsOpacity,x,contentY,height,width" }
        }
    }
}
