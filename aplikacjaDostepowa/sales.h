#ifndef SALES_H
#define SALES_H

#include <QDialog>

namespace Ui {
class Sales;
}

class Sales : public QDialog
{
    Q_OBJECT

public:
    explicit Sales(QWidget *parent = nullptr);
    ~Sales();

private slots:
    void on_closeBtn_clicked();

    void on_addSaleBtn_clicked();

private:
    Ui::Sales *ui;
};

#endif // SALES_H
