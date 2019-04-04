#ifndef CLIENT_H
#define CLIENT_H

#include <QDialog>

namespace Ui {
class Client;
}

class Client : public QDialog
{
    Q_OBJECT

public:
    explicit Client(QWidget *parent = nullptr);
    ~Client();

private slots:
    void on_addBtn_clicked();

    void on_closeBtn_clicked();

private:
    Ui::Client *ui;
};

#endif // CLIENT_H
