#include "sales.h"
#include "ui_sales.h"

#include "login.h"

Sales::Sales(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Sales)
{
    ui->setupUi(this);


    ui->comboBox->addItem("OC posiadaczy pojazdów mechanicznych");
    ui->comboBox->addItem("AC posiadaczy pojazdów mechanicznych");
    ui->comboBox->addItem("NNW posiadaczy pojazdów mechanicznych");
    ui->comboBox->addItem("OC + NWW posiadaczy pojazdów mech");
    ui->comboBox->addItem("OC + AC posiadaczy pojazdów mech");
    ui->comboBox->addItem("OC + AC + NWW posiadaczy pojazdów mech");
    ui->comboBox->addItem("Assistance dla posiadaczy poj mech");
    ui->comboBox->addItem("budynków w gospodarstwie rolnym");
    ui->comboBox->addItem("budynków/mieszkań");
    ui->comboBox->addItem("OC w związku z wykonywanym zawodem");
    ui->comboBox->addItem("ubezpieczenie na życie");
    ui->comboBox->addItem("ubezpieczenie NWW");


    Login conn;
    if (!conn.connectionOpen())
        ui->statusLabel->setText("Nie można połączyć z bazą danych");
    else
        ui->statusLabel->setText("Połączono z bazą danych");
}

Sales::~Sales()
{
    delete ui;
}

void Sales::on_closeBtn_clicked()
{
    close();
}

void Sales::on_addSaleBtn_clicked()
{
    Login conn;

    int idProd=0;
    int idClient=0;
    int idEmp=0;

    idEmp = ui->idEdit->text().toInt();

    QString str = ui->comboBox->currentText();
    idClient = ui->clientEdit->text().toInt();

    QString saleDate, beginDate, finDate, attentions, city;

    int value=0;

    saleDate = ui->saleDateEdit->text();
    beginDate = ui->beginEdit->text();
    finDate = ui->finishEdit->text();

    value = ui->valuelEdit->text().toInt();
    attentions = ui->textEdit->toPlainText();

    city = conn.getLocation();


    if (!conn.connectionOpen())
        ui->statusLabel->setText("Nie można połączyć z bazą danych");
    else
        ui->statusLabel->setText("Połączono z bazą danych");

    QSqlQuery query;

    query.prepare("select id_produkt from ubezpieczenia where nazwa_ubezp=?");
    query.bindValue(0,str);
    if (query.exec()) {
        int count=0;
        while (query.next()) {
            idProd = query.value(0).toInt();
            ++count;
        }

        if (count < 1) {
            qDebug() << "Nie znaleziono ubezpieczenia";
            return;
        }
        else {
            qDebug() << "Znaleziono ubezpieczenia";
        }
    }

    query.clear();

    query.prepare("select * from klienci where id_klient=?");
    query.bindValue(0,idClient);
    if (query.exec()) {
        int count=0;
        while (query.next()) {
            ++count;
        }

        if (count < 1) {
            qDebug() << "Nie znaleziono klienta o podanym id";
            return;
        }
        else {
            qDebug() << "Znaleziono klienta";
        }
    }

    query.clear();
    query.prepare("select * from pracownicy where id_prac=?");
    query.bindValue(0,idEmp);
    if (query.exec()) {
        int count=0;
        while (query.next()) {
            ++count;
        }

        if (count < 1) {
            qDebug() << "Nie znaleziono pracownika";
            return;
        }
        else {
            qDebug() << "Znaleziono pracownika";
        }
    }

    query.clear();
//wstaw_dane_sprzedazy (2,1,1,to_date('2018-07-03', 'RRRR-MM-DD'),'Wro',to_date('2018-07-10', 'RRRR-MM-DD'),to_date('2019-07-09', 'RRRR-MM-DD'),500,'brak');
    query.prepare("call wstaw_dane_sprzedazy(?, ?, ?, to_date(?,'RRRR-MM-DD'),?,to_date(?, 'RRRR-MM-DD'),to_date(?, 'RRRR-MM-DD'),?,?)");
    query.bindValue(0, idProd);
    query.bindValue(1, idClient);
    query.bindValue(2, idEmp);
    query.bindValue(3, saleDate);
    query.bindValue(4, city);
    query.bindValue(5, beginDate);
    query.bindValue(6, finDate);
    query.bindValue(7, value);
    query.bindValue(8, attentions);

    if (!query.exec()) {
        qDebug() << "Blad w wykonaniu procedury";
        qDebug() << query.lastError().text();
    }

    //conn.connectionClose();
}
