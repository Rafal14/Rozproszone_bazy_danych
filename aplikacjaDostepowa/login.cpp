#include "login.h"
#include "ui_login.h"

Login::Login(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::Login)
{
    ui->setupUi(this);

    ui->comboBox->addItem("Wrocław");
    ui->comboBox->addItem("Poznań");

    if (!connectionOpen())
        ui->label->setText("Nie można połączyć z bazą danych");
    else
        ui->label->setText("Połączono z bazą danych");
}

Login::~Login()
{
    delete ui;
}

void Login::connectionClose()
{
    db.close();
    db.removeDatabase(QSqlDatabase::defaultConnection);
}

bool Login::connectionOpen()
{
    QString str = ui->comboBox->currentText();


    db = QSqlDatabase::addDatabase("QOCI");

    db.setHostName("localhost");
    db.setDatabaseName("orcl");

    location = "Wro";

    if (str == "Poznań") {
        db.setHostName("192.168.56.101");
        db.setDatabaseName("orclcdb");

        location = "Poz";
    }

    db.setUserName("test");
    db.setPassword("test");

    if (!db.open()) {
        qDebug() << "Nie można połączyć z bazą danych";
        return false;
    }
    else {
        qDebug() << "Nie można połączyć z bazą danych";
        return true;
    }
}

QString Login::getLocation()
{
    return location;
}

int Login::getIdEmp()
{
    return id_emp;
}



void Login::on_loginBtn_clicked()
{
    QString loginStr, passwdStr;
    loginStr  = ui->loginEdit->text();
    passwdStr = ui->passEdit->text();

    //obsługa błędu połączenia
    if (!connectionOpen()){
        qDebug() << "Nie można połączyć się z bazą danych";
        return;
    }

    connectionOpen();
    QSqlQuery query;

    query.prepare("select * from pracownicy where id_prac='"+loginStr +"' and haslo='"+passwdStr+"'");

    if( query.exec() ) {

        int countRec = 0;
        while(query.next()) {
            countRec++;
        }

        if(countRec == 1) {
            ui->label->setText("Login i hasło są poprawne");

            if (loginStr=="1") {
                id_emp = 1;
            }
            else if (loginStr=="2") {
                id_emp = 2;
            }
            else if (loginStr=="3") {
                id_emp = 3;
            }
            else if (loginStr=="4") {
                id_emp = 4;
            }

            connectionClose();
            this->hide();
            Aplikacja aplikacja;
            aplikacja.setModal(true);
            aplikacja.exec();
        }
        if(countRec < 1)
            ui->label->setText("Login lub hasło jest niepoprawne");
    }
}
