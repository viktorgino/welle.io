#ifndef STATIONELEMENT_H
#define STATIONELEMENT_H

#include <QObject>
#include <QVariant>

class StationElement : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString stationName MEMBER m_stationName NOTIFY stationNameChanged)
    Q_PROPERTY(QString channelName MEMBER m_channelName NOTIFY channelNameChanged)

public:
    explicit StationElement(QString stationName, QString channelName, QObject *parent = 0);

private:
    QString m_stationName;
    QString m_channelName;

signals:
    void stationNameChanged();
    void channelNameChanged();
};

#endif // STATIONELEMENT_H
