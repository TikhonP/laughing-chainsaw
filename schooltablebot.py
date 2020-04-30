from telebot import types, TeleBot, apihelper
import pandas as pd
import sys
import datetime
import threading
import time
import json

filename = 'botconfig.json'

with open(filename) as f:
    config = json.load(f)


token = config['token']
apihelper.proxy = {'https': 'socks5h://geek:socks@t.geekclass.ru:7777'}
bot = TeleBot(token)

filepath = config['datapath']


def convertdays(day):
    if day == 'Понедельник':
        return 0
    elif day == 'Вторник':
        return 1
    elif day == 'Среда':
        return 2
    elif day == 'Четверг':
        return 3
    elif day == 'Пятница':
        return 4
    elif day == 'Суббота':
        return 5
    elif day == 'Воскрексенье':
        return 6
    else:
        return "UnknownDay"


def parsetable(table):
    data = pd.read_csv(table)
    newdata = {}
    day = -1
    for j, i in data.iterrows():
        if type(i['День недели']) != float:
            day = convertdays(i['День недели'])
            newdata[day] = []
        subject = i['Предмет']
        if type(subject) == float:
            continue
        if '(' in list(subject):
            s = subject.split(sep='(')
            subject = s[0]
            group = s[1][0]
        else:
            group = None
        subject = subject.strip()
        t = i['Время урока']
        t = t.split()
        try:
            time = t[1]
        except:
            time = t[0].split(sep=':')[1] + ':' + t[0].split(sep=':')[2]
        if len(time) == 4:
            time = '0' + time
        if len(t) >= 3:
            if len(t) == 4:
                metat = t[2] + ' ' + t[3]
            metat = t[2]
        else:
            metat = None
        if i['Идентификатор в zoom'] == 'см. в чате':
            passw = 'см. в чате'
            url = None
        else:
            passw = i['Идентификатор в zoom'].split(sep='пароль: ')[1]
            url = i['Ссылки для удобства']
        newdata[day].append({
            "subject": subject,
            "group": group,
            "time": time,
            "metat": metat,
            "passw": passw,
            "url": url,
        })
    return newdata


def checktime(data):
    while 1:
        today = datetime.datetime.today()
        nowlist = data[today.weekday()]
        for i in nowlist:
            # print(i['time'], today.strftime("%H:%M"))
            if i['time'] == today.strftime("%H:%M"):
                sendnotification(i)
        time.sleep(60)


def send_msg(message, user):
    try:
        bot.send_message(
            user, message, disable_web_page_preview=True, parse_mode="Markdown")
        print(f"<{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}> Successfully sent message to '{user}'")
        return None
    except apihelper.ApiException as e:
        e=str(e)
        if e.split(sep='\n')[1]=='[b\'{"ok":false,"error_code":403,"description":"Forbidden: bot was blocked by the user"}\']':
            return user
        else:
            print(f'''
            ERROR with user "{user}"
            -----------------
            <{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}>
            -----------------
            {e}
            -----------------
            ''')
            return None



def sendnotification(event):
    message = f"*{event['subject']}*\nУрок сейчас"
    if event['metat'] != None:
        message += " "+event['metat']
    if event['group'] != None:
        message += f" у {event['group']} группы"
    message += f", пароль: `{event['passw']}`\n[НАЖМИ СЮДА, ЧТОБЫ ПОДКЛЮЧИТЬСЯ]({event['url']})"
    i = 0
    blocklist = []
    for u in config['users']:
        if event['group'] != None:
            if event['subject'] == 'Английский':
                if config['users'][u][0] == event['group']:
                    du = send_msg(message, u)
                    i += 1
            else:
                if config['users'][u][1] == event['group']:
                    du = send_msg(message, u)
                    i += 1
        else:
            du = send_msg(message, u)
            i += 1
        if du!=None:
            blocklist.append(du)
    if len(blocklist)>0:
        for b in blocklist:
            config['users'].pop(b, None)
        with open(filename, 'w') as outfile:
            json.dump(config, outfile)
        print(f"<{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}> Users {blocklist}, blocked")
    print(f"<{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}> Sended message '{message}' {i} times.")



@bot.message_handler(commands=['start'])
def start(msg):
    user = msg.chat.id
    print(f"<{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}> '@{msg.from_user.username}' chat pressed start handler")
    if str(user) not in config['users']:
        # print(config['users'], user)
        keyboard = types.InlineKeyboardMarkup()
        firstenggroup = types.InlineKeyboardButton(
            text="1 группа", callback_data="firstenggroup")
        secondenggroup = types.InlineKeyboardButton(
            text="2 группа", callback_data="secondenggroup")
        keyboard.add(firstenggroup)
        keyboard.add(secondenggroup)
        bot.send_message(
            user, "Выберите группу по английскому:", reply_markup=keyboard)
    else:
        bot.send_message(user, "❌ Вы уже подписаны на уведомления об уроках")


@bot.callback_query_handler(func=lambda call: True)
def callback_inline(call):
    user = call.message.chat.id
    if call.message:
        if call.data == "firstenggroup":
            config['users'][str(user)] = ['1']
            keyboard = types.InlineKeyboardMarkup()
            firstothgroup = types.InlineKeyboardButton(
                text="1 группа", callback_data="firstothgroup")
            secondothgroup = types.InlineKeyboardButton(
                text="2 группа", callback_data="secondothgroup")
            keyboard.add(firstothgroup)
            keyboard.add(secondothgroup)
            bot.send_message(
                user, "Выберите группу по математике/физике:", reply_markup=keyboard)
        elif call.data == "secondenggroup":
            config['users'][str(user)] = ['2']
            keyboard = types.InlineKeyboardMarkup()
            firstothgroup = types.InlineKeyboardButton(
                text="1 группа", callback_data="firstothgroup")
            secondothgroup = types.InlineKeyboardButton(
                text="2 группа", callback_data="secondothgroup")
            keyboard.add(firstothgroup)
            keyboard.add(secondothgroup)
            bot.send_message(
                user, "Выберите группу по математике/физике:", reply_markup=keyboard)
        elif call.data == "firstothgroup":
            config['users'][str(user)].append('1')
            config['users'][str(user)].append(call.from_user.username)
            # config['users'][user].append(call.message.chat.from_user.username)
            with open(filename, 'w') as outfile:
                json.dump(config, outfile)
            bot.send_message(
                user, "✅ Вы подписались на уведомления об уроках в классе 10-3")
            print(f'''
            User joined @{call.from_user.username}
            ---------------------------
            <{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}>
            ---------------------------
            {config['users'][str(user)]}
            ''')
        elif call.data == "secondothgroup":
            config['users'][str(user)].append('2')
            config['users'][str(user)].append(call.from_user.username)
            # config['users'][user].append(call.message.chat.from_user.username)
            with open(filename, 'w') as outfile:
                json.dump(config, outfile)
            bot.send_message(
                user, "✅ Вы подписались на уведомления об уроках в классе 10-3")
            print(f'''
            User joined @{call.from_user.username}
            ---------------------------
            <{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}>
            ---------------------------
            {config['users'][str(user)]}
            ''')


if __name__ == '__main__':
    print('''
		--------------------------------
		Tikhon Systems Inc.
		All rights reserved (c) 2020
		--------------------------------
	''')
    print(f"<{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}> Parsing data...")
    data = parsetable(filepath)
    print(f"<{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}> Parsing complete. Staring checking thread...")
    t = threading.Thread(target=checktime, args=(data, ))
    t.start()
    print(f"<{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}> Done. Server ready!")


    # for u in config['users']:
    #     send_msg("Тест, крыса найдена, проверка симтомов", u)

    while True:
        try:
            bot.polling(none_stop=True)
        except Exception as e:
            print(f'''
            BOT POLLING drop
            -----------------
            <{datetime.datetime.today().strftime('%d.%m.%Y %H:%M:%S')}>
            -----------------
            {e}
            -----------------
            Sleeping 15 seconds...
            ''')
            time.sleep(15)
