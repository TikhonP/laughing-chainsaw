#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct burthdates {
        int day;
        int month;
        int year;
};

enum passtypes {citizen, international, other};

struct identitys {
        enum passtypes passport;
        char passbatsh[5];
        char passnumber[20];
        struct burthdates burthdate;
};

enum transporttypes {CAR, TROYKA, STRELKA};

struct transports {
        char number[11];
        enum transporttypes transport;
};

enum typespass {WORK, MED, OTHER};

struct places {
        char inn[11];
        char organisationnameortarget[21];
        char address[40];
};

typedef struct {
        enum typespass typepass;
        struct identitys identity;
        struct transports transport;
        struct places place;
} pass;

int getinfo(pass *p) {
        printf("Пожалуйста выберите тип пропуска, введите соответствующую цифру (1/2/3):\n1 — цифровой пропуск для работающих;\n2 — разовая поездка для посещения медицинской организации;\n3 — разовая поездка в иных целях. Также можете дважды нажать enter для этого варианта.\n> ");
        char buffer[40];
        getchar();
        fgets(buffer, 2, stdin);
        if (buffer[0]=='1')
                p->typepass = WORK;
        else if (buffer[0]=='2')
                p->typepass = MED;
        else if ((buffer[0]=='3') || (buffer[0]=='\n'))
                p->typepass = OTHER;
        else
                return 1;
        printf("Пожалуйста выберите тип документа удостоверяющего личность, введите соответствующую цифру (1/2/3):\n1 - паспорт гражданина РФ, также можете дважды нажать enter для этого варианта;\n2 - иностранный паспорт;\n3 - иной документ.\n> ");
        getchar();
        fgets(buffer, 2, stdin);
        if ((buffer[0]=='1') || (buffer[0]=='\n'))
                p->identity.passport = citizen;
        else if (buffer[0]=='2')
                p->identity.passport = international;
        else if (buffer[0]=='3')
                p->identity.passport = other;
        else
                return 1;
        if ((p->identity.passport == citizen) || (p->identity.passport == international)) {
                printf("Введите серию паспорта.\n> ");
                getchar();
                fgets(buffer, 4, stdin);
                strcpy(p->identity.passbatsh, buffer);
                printf("Введите номер паспорта.\n> ");
                getchar();
                fgets(buffer, 6, stdin);
                strcpy(p->identity.passnumber, buffer);
        } else {
                printf("Введите номер документа\n> ");
                getchar();
                fgets(buffer, 20, stdin);
                strcpy(p->identity.passnumber, buffer);
        }
        printf("Введите год рождения (4 цифры)\n> ");
        getchar();
        fgets(buffer, 4, stdin);
        p->identity.burthdate.year = atoi(buffer);
        printf("Введите месяц рождения (2 цифры)\n> ");
        getchar();
        fgets(buffer, 2, stdin);
        p->identity.burthdate.month = atoi(buffer);
        printf("Введите день рождения (2 цифры)\n> ");
        getchar();
        fgets(buffer, 2, stdin);
        p->identity.burthdate.day = atoi(buffer);
        printf("Пожалуйста, выберите средство передвижения, введите соответствующую цифру (1/2/3):\n1 - Автомобиль, также можете дважды нажать enter для этого варианта;\n2 - Общественный транспорт, карта тройка;\n3 - Общественный транспорт, карта стрелка.\n> ");
        getchar();
        fgets(buffer, 2, stdin);
        if ((buffer[0]=='1') || (buffer[0]=='\n')) {
                p->transport.transport = CAR;
                printf("Пожалуйста, введите номер автомобиля.\n> ");
        } else if (buffer[0]=='2') {
                p->transport.transport = TROYKA;
                printf("Пожалуйста, введите номер карты тройка.\n> ");
        } else if (buffer[0]=='3') {
                p->transport.transport = STRELKA;
                printf("Пожалуйста, введите номер карты стрелка.\n> ");
        } else
                return 1;
        getchar();
        fgets(buffer, 10, stdin);
        strcpy(p->transport.number, buffer);
        if (p->typepass == MED) {
                printf("Введите краткое наименование медецинской организации.\n> ");
                // TODO: Добавить проверку на 20 символов
                getchar();
                fgets(buffer, 20, stdin);
                strcpy(p->place.organisationnameortarget, buffer);
        } else if (p->typepass == WORK) {
                printf("Введите ИНН организации.\n> ");
                getchar();
                fgets(buffer, 10, stdin);
                strcpy(p->place.inn, buffer);
                printf("Введите краткое наименование организации.\n> ");
                // TODO: Добавить проверку на 20 символов
                getchar();
                fgets(buffer, 20, stdin);
                strcpy(p->place.organisationnameortarget, buffer);
        } else if (p->typepass == OTHER) {
                printf("Введите цель выхода (не более 20 символов).\n> ");
                getchar();
                fgets(buffer, 20, stdin);
                strcpy(p->place.organisationnameortarget, buffer);
                printf("Введите адрес пункта назначения.\n> ");
                getchar();
                fgets(buffer, 40, stdin);
                strcpy(p->place.address, buffer);
        }

        printf("\nДанные записаны. Обработка результата.\n");

        return 0;
}

void printanswer(pass *p) {
}

int main() {
        while (1) {
                pass mypass;
                printf("----\nMoscow digital pass for SMS creator\nTikhon Systems Inc. 2020 (c) all rights reserved\n----\nFor quiting press ctrl-c\n");
                if (getinfo(&mypass)!=0) {
                        printf("Неверный формат, перезагрузка...\n");
                        continue;
                }
        }
}
