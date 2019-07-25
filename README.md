## Set - Сет/Набор рамок

| Название поля | Тип данных | Описание |
|---|---|---|
| buyId | String | Id для покупки |
| name | String | Отображаемоем пользователю название |
| templates | [Template] | Массив темплейтов входящих в этот |
| themeColor | UIColor | Цвет сета |
| priority | Int | Приоритет отображения |


## Template - Шаблон

| Название поля | Тип данных | Описание |
|---|---|---|
| name | String | Название шаблона. Используется для получения превьюшки |
| elements | [TemplateItem] | Айтемы из которых состоит шаблон |
| backGroundColor | UIColor | Цвет фона |
| backGroundImage | String | Название картинки фона |


## TemplateSettings - настройки элемента в конкретном шаблоне

| Название поля | Тип данных | Описание |
|---|---|---|
| midX | Float | Центр по X |
| midY | Float | Центр по Y |
| angle | Float | Угол поворота в радианах |
| widthScale | Float | На сколько ширина элемента меньше ширины слайда |


## AbstractTemplateItem - Абстрактный класс для всех айтемов в шаблоне

| Название поля | Тип данных | Описание |
|---|---|---|
| settings | TemplateSettings | Настройки этого элемента в шаблоне |


## PhotoFrameInTemplate - Рамка для фотографий в шаблоне

| Название поля | Тип данных | Описание |
|---|---|---|
| item | PhotoFrameItem | Рамка |
| plusLocationX | Float | Позиция плюса по Х |
| plusLocationY | Float | Позиция плюса по Y |
| closeButtonPosition | Int | Нахождения крестика 1 - справа вверху, 2 - справа внизу, 3 - слева внизу, 4 - слева вверху |


## StuffItemInTemplate - Скотчики в шаблоне

| Название поля | Тип данных | Описание |
|---|---|---|
| itemId | Int | ID скотчика |


## TextItemInTemplate - Текстовая рамка в шаблоне

| Название поля | Тип данных | Описание |
|---|---|---|
| ratio | Float | Соотношение сторон |


## ViewInTemplate - Просто вьюха в шаблоне

| Название поля | Тип данных | Описание |
|---|---|---|
| backGroundColor | UIColor | Цвет фона |
| backGroundImage | String | Название картинки фона |


## AbstractItem - Абстрактный класс для всех айтемов

| Название поля | Тип данных | Описание |
|---|---|---|
| id | Integer | ID уникальный |
| buyId | String | Id для покупки |


## StuffItem - Скотчик/Лепесток прочий элемент являщийся картинкой

| Название поля | Тип данных | Описание |
|---|---|---|
| imageName | String | Название файла с картинкой |


## TextItem - Текст

| Название поля | Тип данных | Описание |
|---|---|---|

## TextSettings - настройки текста

| Название поля | Тип данных | Описание |
|---|---|---|
| aligment | Int | Выравнивание 0 - лево, 1 - центр, 2 - право |
| fontSize | Float | Размер шрифта |
| color | UIColor | Цвет текста |
| kern | Float | Расстояние между буквами |
| lineSpacing | Float | Расстояние между строками |
| fontName | String | Название шрифта |



## PhotoFrameItem - Шаблон с рамкой для фото

| Название поля | Тип данных | Описание |
|---|---|---|
| frameName | String | Название файла с рамкой |
| aspectRatioFrame | Float | Соотношение сторон рамки |
| midX | Float | Центр места для фотографии в рамке по Х |
| midY | Float | Центр места для фотографии в рамке по Y |
| aspectRatioPhoto | Float | Соотношение сторон места для фотографии |
| widthScale | Float | На сколько ширина места под фотографию меньше ширины рамки |
| roundCorner | Float | Ширина скругления места под рамку относительно ширины. от 0 до 0.5 |

