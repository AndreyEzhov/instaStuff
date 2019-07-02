Set - Сет/Набор рамок
|Buy ID|String|Id для покупки|
|Name|String|Отображаемоем пользователю название|
|Templates|[Template]|Массив темплейтов входящих в этот
***

Template - Шаблон
|Buy ID|String|Id для покупки|
|Elements|[TemplateItem]|Айтемы из которых состоит шаблон|


TemplateItem - Айтем для шаблона
|Buy ID|String|Id для покупки|
|Elements|[AbstractTemplateItem]|Айтемы из которых состоит шаблон|


AbstractTemplateItem - Абстрактный класс для всех айтемов
|Item|AbstractItem|Какой-то элемент в шаблоне|
|Settings|TemplateSettings|Настройки этого элемента в шаблоне|


TemplateSettings - настройки элемента в конкретном шаблоне
|midX|Float|Центр по X|
|midY|Float|Центр по Y|
|angle|Float|Угол поворота в радианах|
|widthScale|Float|На сколько ширина элемента меньше ширины слайда|


AbstractItem - Абстрактный класс для всех айтемов
|Buy ID|String|Id для покупки|


PhotoFrameItem - Шаблон с рамкой для фото
|Buy ID|String|Id для покупки|
|Elements|[TemplateItem]|Айтемы из которых состоит шаблон|
