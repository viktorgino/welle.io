import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Layouts 1.1

// Source: http://www.mimec.org/node/399 14. May 2016

QtObject {
    function dp( x ) {
        return Math.round( x * Settings.dpiScaleFactor );
    }

    function em( x ) {
        return Math.round( x * TextSingleton.font.pixelSize );
    }
}
