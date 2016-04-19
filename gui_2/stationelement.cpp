#include "stationelement.h"

StationElement::StationElement(QString const stationName, QString const channelName, QObject *parent) : QObject(parent)
{
    setProperty("stationName",stationName);
    setProperty("channelName",channelName);
}
