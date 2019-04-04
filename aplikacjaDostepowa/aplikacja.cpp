#include "aplikacja.h"
#include "ui_aplikacja.h"

Aplikacja::Aplikacja(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Aplikacja)
{
    ui->setupUi(this);

    Login conn;
    if (!conn.connectionOpen())
        ui->statusLabel->setText("Nie można połączyć z bazą danych");
    else
        ui->statusLabel->setText("Połączono z bazą danych");

    ui->comboBox->addItem("typy ubezpieczeń");

    ui->comboBox->addItem("wszyscy klienci");
    ui->comboBox->addItem("wszyscy klienci indywidualni");
    ui->comboBox->addItem("wszyscy klienci biznesowi");
    ui->comboBox->addItem("klienci z regionu Poznań");
    ui->comboBox->addItem("klienci z regionu Wrocław");

    ui->comboBox->addItem("cała sprzedaż");
    ui->comboBox->addItem("cała sprzedaż dla klientów indywidualnych");
    ui->comboBox->addItem("cała sprzedaż dla klientów biznesowych");
}

Aplikacja::~Aplikacja()
{
    delete ui;
}

void Aplikacja::on_displayBtn_clicked()
{
    Login conn;


    QString loginStr, passwdStr;
 //   loginStr  = ui->loginEdit->text();
 //   passwdStr = ui->passEdit->text();

    //obsługa błędu połączenia
    if (!conn.connectionOpen()){
        qDebug() << "Nie można połączyć się z bazą danych";
        return;
    }

    conn.connectionOpen();


    //wyświetlenie żadanej tabeli
    tabModel = new QSqlTableModel(this, conn.db);


    QString str = ui->comboBox->currentText();

    if (str == "typy ubezpieczeń") {
        tabModel->setTable("mv_ubezpieczenia");
    }
    else if (str == "wszyscy klienci") {
        tabModel->setTable("wszyscy_klienci");
    }
    else if (str == "wszyscy klienci indywidualni") {
        tabModel->setTable("wszyscy_klienci_ind");
    }
    else if (str == "wszyscy klienci biznesowi") {
        tabModel->setTable("wszyscy_klienci_biz");
    }
    else if (str == "klienci z regionu Poznań") {
        if (conn.getLocation()=="Poz")
            tabModel->setTable("klienci");
        else
            tabModel->setTable("klienciPoznan");
    }
    else if (str == "klienci z regionu Wrocław") {
        if (conn.getLocation()=="Wro")
            tabModel->setTable("klienci");
        else
            tabModel->setTable("klienciWroclaw");
    }
    else if (str == "cała sprzedaż") {
        tabModel->setTable("cala_sprzedaz");
    }
    else if (str == "cała sprzedaż dla klientów indywidualnych") {
        tabModel->setTable("cala_sprzedaz_ind");
    }
    else if (str == "cała sprzedaż dla klientów biznesowych") {
        tabModel->setTable("cala_sprzedaz_biz");
    }


    tabModel->setEditStrategy(QSqlTableModel::OnManualSubmit);
    tabModel->select();

    ui->tableView->setModel(tabModel);

    ui->tableView->show();

    conn.connectionClose();
}

void Aplikacja::on_addClientBtn_clicked()
{
    Client client;
    client.setModal(true);
    client.exec();
}

void Aplikacja::on_addSaleBtn_clicked()
{
    Sales sales;
    sales.setModal(true);
    sales.exec();
}
