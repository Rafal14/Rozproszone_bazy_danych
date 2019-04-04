#ifndef APLIKACJA_H
#define APLIKACJA_H

#include <QDialog>

#include <QtDebug>
#include <QString>
#include <QtSql>
#include <QFileInfo>
#include <QSqlTableModel>


#include "login.h"
#include "client.h"
#include "sales.h"

namespace Ui {
class Aplikacja;
}

class Aplikacja : public QDialog
{
    Q_OBJECT

public:
    explicit Aplikacja(QWidget *parent = nullptr);
    ~Aplikacja();

private slots:
    void on_displayBtn_clicked();

    void on_addClientBtn_clicked();

    void on_addSaleBtn_clicked();

private:
    Ui::Aplikacja *ui;

    //model tabeli
    QSqlTableModel *tabModel;
};

#endif // APLIKACJA_H
