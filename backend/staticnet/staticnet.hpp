/**
 * Filename: staticnet.hpp
 *
 * XCITE is a secure platform utilizing the XTRABYTES Proof of Signature
 * blockchain protocol to host decentralized applications
 *
 * Copyright (c) 2017-2018 Zoltan Szabo & XTRABYTES developers
 *
 * This file is part of an XTRABYTES Ltd. project.
 *
 */

#ifndef STATICNET_HPP
#define STATICNET_HPP

#include <QObject>

#include <QSslConfiguration>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QSignalMapper>
#include <QJsonObject>
#include <QJsonArray>
#include <QThread>

#include <boost/thread/mutex.hpp>

class StaticNetHttpClient:  public QObject  {
    Q_OBJECT
    
public:
    StaticNetHttpClient(const QString &endpoint, QObject *parent = 0 );
    ~StaticNetHttpClient() {}
    QNetworkReply *reply;
    void request(const QJsonArray *params);
    static QStringList usedUtxo;

public Q_SLOTS:
    void slotNetworkError(QNetworkReply::NetworkError error);
    void onResponse(QNetworkReply *res);

signals:
    void response(QJsonArray params, QJsonObject res);
    void error(QNetworkReply::NetworkError); // FIXMEEE


private:
    QNetworkRequest req;
    QNetworkAccessManager *manager;

};

class SendcoinWorker : public QObject {
    Q_OBJECT

public:
    SendcoinWorker(const QJsonArray *params);
    ~SendcoinWorker();


public slots:
    void process();

signals:
    void finished();
    void error(QString err);
    void sendcoinFailed();
    void txTooBig();


public Q_SLOTS:
    void unspent_request(const QJsonArray *params);
    void unspent_onResponse(QString id, QString utxo, QString target, QString amount, QString privkey, QStringList usedUtxo);
    void calculate_fee(const QString inputs, const QString outputs);
    void txbroadcast_request(const QJsonArray *params);
    void txbroadcast_onResponse(QJsonArray params, QJsonObject );


private:
    std::string secret;
    std::string hexscript;
    std::string sender_address;
    std::string target_address;
    std::string value_str;
    QString trace_id;
    QString module;
    std::string RawTransaction;
    StaticNetHttpClient *client;
    bool tooBig;
    int nMinFee;
    int nBaseFee = 100000000;
};


class SnetKeyWordWorker : public QObject {
    Q_OBJECT

public:
    SnetKeyWordWorker(const QString *_msg);
    ~SnetKeyWordWorker();

public slots:
    void process();

signals:
    void finished();
    void error(QString err);
    void response(QVariant response);

public Q_SLOTS:
    void request(const QJsonArray *params);
    void srequest(const QJsonArray *params);
    void onResponse(QJsonArray params, QJsonObject );
    int errorString(QString errorstr);

private:
    QString msg;
    QString target_addr;
    QString send_amount;
    QString priv_key;
    QStringList pendingUtxo;
    void CmdParser(const QJsonArray *params);
    StaticNetHttpClient *client;
    void help();
    void sendcoin(const QJsonArray *params);
};


class StaticNet : public QObject {
    Q_OBJECT

public:
    StaticNet(QObject *parent = 0) : QObject(parent) {}
    ~StaticNet() {}
    void Initialize();
    bool CheckUserInputForKeyWord(const QString msg, int *traceID);

    QString GetConnectStr() {
        return ConnectStr;
    };

    int GetNewTraceID() {
        boost::unique_lock<boost::mutex> scoped_lock(mutex);
        return ++traceID;
    };


public slots:
    void errorString(const QString error);
    void onResponseFromStaticnet(QJsonObject response) {
        qDebug() << "staticnet response recevied";       
    }

signals:
	 void ResponseFromStaticnet(QJsonObject);
     void sendFee(QString fee_, QString rawTx_, QString receiver_, QString sender_, QString sendAmount_, QString traceId_);
     void rawTxFailed();
     void fundsLow();
     void utxoError();
     void txFailed(QString id);
     void txSuccess(QString id, QString msg);

private:
    boost::mutex mutex;
    int traceID;
    QString ConnectStr;
};

extern StaticNet staticNet;

#endif  // STATICNET_HPP
