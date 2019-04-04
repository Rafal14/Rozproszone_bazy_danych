#include "client.h"
#include "ui_client.h"

#include "login.h"

Client::Client(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Client)
{
    ui->setupUi(this);

    ui->removeBtn->setVisible(false);


    //
    ui->updateBtn->setVisible(false);

    Login conn;
    if (!conn.connectionOpen())
        ui->statusLabel->setText("Nie można połączyć z bazą danych");
    else
        ui->statusLabel->setText("Połączono z bazą danych");

    ui->comboBox->addItem("klient indywidualny");
    ui->comboBox->addItem("klient biznesowy");
}

Client::~Client()
{
    delete ui;
}

void Client::on_addBtn_clicked()
{
    Login conn;


    QString firstNameStr, nameStr, peselStr;
    QString empStr, nipStr;
    QString emailStr, telStr, addrStr, cityStr, postStr;



    firstNameStr = ui->firstNameEdit->text();
    nameStr= ui->nameEdit->text();
    peselStr = ui->peselEdit->text();

    empStr = ui->empEdit->text();
    nipStr = ui->nipEdit->text();

    emailStr = ui->emailEdit->text();
    telStr = ui->telEdit->text();
    addrStr = ui->addrEdit->text();
    cityStr = ui->cityEdit->text();
    postStr = ui->postEdit->text();


    //obsługa błędu połączenia
    if (!conn.connectionOpen()){
        qDebug() << "Nie można połączyć się z bazą danych";
        return;
    }

    conn.connectionOpen();

    QString str = ui->comboBox->currentText();

    if (str == "klient indywidualny") {
        if (firstNameStr != "") {
            if (nameStr != "") {
                if (peselStr !="") {
                    if (postStr != "") {
                        QSqlQuery query;

                        query.prepare("CALL WSTAW_DANE_KLIENTA (?,?,?,NULL,?,NULL,?,?,?,?,?)");
                        query.bindValue(0, 0);
                        query.bindValue(1, firstNameStr);
                        query.bindValue(2, nameStr);
                        query.bindValue(3, peselStr);
                        query.bindValue(4, emailStr);
                        query.bindValue(5, telStr);
                        query.bindValue(6, addrStr);
                        query.bindValue(7, cityStr);
                        query.bindValue(8, postStr);

                        query.exec();
                    }
                }
            }
        }
    }
    if (str == "klient biznesowy") {
        if (empStr !=""){
            if (nipStr !=""){
                if (postStr !=""){
                    QSqlQuery query;

                    query.prepare("CALL WSTAW_DANE_KLIENTA (?,NULL,NULL,?,NULL,?,?,?,?,?,?)");
                    query.bindValue(0, 1);
                    query.bindValue(1, empStr);
                    query.bindValue(2, nipStr);
                    query.bindValue(3, emailStr);
                    query.bindValue(4, telStr);
                    query.bindValue(5, addrStr);
                    query.bindValue(6, cityStr);
                    query.bindValue(7, postStr);

                    query.exec();
                }
            }
        }
    }


    conn.connectionClose();
}

void Client::on_closeBtn_clicked()
{
    close();
}
