#ifndef LOGIN_H
#define LOGIN_H

#include "aplikacja.h"

#include <QMainWindow>

#include <QtDebug>
#include <QString>
#include <QtSql>
#include <QFileInfo>


namespace Ui {
class Login;
}

class Login : public QMainWindow
{
    Q_OBJECT

public:
    QSqlDatabase db;


    void connectionClose();
    bool connectionOpen();

    QString getLocation();

    int getIdEmp();

    explicit Login(QWidget *parent = nullptr);
    ~Login();

private slots:
    void on_loginBtn_clicked();

private:
    Ui::Login *ui;
    QString location;

    int id_emp;

};

#endif // LOGIN_H
