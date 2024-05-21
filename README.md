# Pharo-I18N

## Project info

The "I18N" project provides Internationalization support for applications written in [Pharo][1] (for instance [Seaside][2] applications). It allows for simple handling of multiple translations of an app without a dependency to other external frameworks (like GetText, ...).

### Project location
The project is located on GitHub at [https://github.com/astares/Pharo-I18N][3]

### Demo

You can checkout a demo in the Lighthouse Seaside sample application. This project is [also on SmalltalkHub][4] and a ready to run image for "Lighthouse" can be found on the [Pharo Contribution CI][5] server. Lighthouse uses the I18N framework to provide  english, german, french, italian, spanish and arabic translation for a web user interface.

### License
The code of I18N is under MIT License.

## Installation
You can load the code either in Pharo easily using the given script:

```Smalltalk
Metacello new
	baseline: 'I18N';
	repository: 'github://astares/Pharo-I18N/src';
	load
```    
    

## How to use
### The basic idea

The basic idea of the framework is instead of hardcoding texts and strings for labels, menu items or other in an application just provide a unique message key. Depending on a translator object this message key resolves to a translation in the specific natural language. So for instance the key #welcome should resolve to 'Welcome' in english, 'Willkommen' in german, 'Bienvenue' in french, ...

Also the framework should be very lean and easy to use in any application built on top of Pharo or maybe in Pharo as well.

### Translations

To perform it's tasks the framework includes a simple class called **"I18NTranslator"** that allows you to manage translators with translations in different languages. 

As the english language is often used to develop by default an english translator is available:

```Smalltalk
I18NTranslator defaultTranslator inspect
```

In the inspector you will see that a translator is responsible for a language (using the ISO code) and manages a translation map.

To access all the translators use

```Smalltalk
I18NTranslator translators inspect
```

So far we have only one translator who can also be accessed using:

```Smalltalk
I18NTranslator forLanguage: 'EN'
```    
## Adding translations

### Manually adding translations

Any translator has a translation map that has to be filled with translations in advance. We do this by using a unique message key (a symbol) and provide the translation:

```Smalltalk
|translator|
translator := I18NTranslator defaultTranslator.
translator translationMap at: #welcome put: 'Welcome'
```
So 

```Smalltalk
(I18NTranslator forLanguage: 'EN') translationMap isEmpty
```

should return *false* as we have added our first translation for the english language.

### Retrieving the translation again

If you have access to the translator the you can retrieve the given translation by just sending a message:

```Smalltalk
I18NTranslator defaultTranslator welcome
```

This should return the 'Welcome' string as the translator we use currently cares about the english language.

*If you look at the implementation of class I18NTranslator you will see that this is handles by overriding #doesNotUnderstand: message. If there is a translation that matches the given selector then the translated string is returned, otherwise the message is handled as a usual Does Not Understand (DNU) message.*  

So far that was not very interesting, but let's move on:

### Translation viewer
After loading the framework you will find a tool called "Translation viewer" in the world menu. Just go the "Browse" menu item and check the "I18N Translations" menu item. When you open the tool right after loading you will notice that the translations are empty.

If we add a translation and open the tool we will see our entry for the english language:

```Smalltalk
|englishTranslator|
englishTranslator := I18NTranslator defaultTranslator.
englishTranslator translationMap at: #welcome put: 'Welcome'.
I18NTranslationViewerApplication run
```

### Adding more languages/translators

Now lets add another translator for a different language, we do this by instantiating a new translator object and registering it as a translator:

```Smalltalk
|germanTranslator|
germanTranslator := (I18NTranslator newForLanguage: 'DE').
I18NTranslator addTranslator: germanTranslator.
```
    
To check if our translator is now a registered translator we can use the following expression:

```Smalltalk
I18NTranslator translators inspect
```

Now two translators are registered with the framework - one for the english and one for german language. Lets open the translation viewer again:

```Smalltalk    
I18NTranslationViewerApplication run
```

You will now notice that the viewer has a new column for the german language. But the entry for our welcome text is still set to nil.

So we have to make it complete and provide also a german translation for the same message key #welcome:

```Smalltalk
|germanTranslator|
germanTranslator := I18NTranslator forLanguage: 'DE'.
germanTranslator translationMap at: #welcome put: 'Willkommen'.
```

If you now open the translation viewer you will see both translations: 'Welcome' for the english language and 'Willkommen' for german language registered with the given message key. So depending on the translator that one asks a different String is returned:

```Smalltalk
(I18NTranslator forLanguage: 'DE') welcome.
```

returns 'Willkommen' and 

```Smalltalk
(I18NTranslator forLanguage: 'EN') welcome.
```

returns 'Welcome'.

If we like we can easily add other languages like french:

```Smalltalk
(I18NTranslator forLanguage: 'FR') translationMap at: #welcome put: 'Bienvenue'.
```

### Using the framework in an application

So the typical use case in an application is to:

1. Load necessary translation from an external source (CSV, Database, ...) into the image
2. Do not harcode strings but access them via a translator object (for instance via a global singleton that can be switched for your application).
4. Allow you user to switch between translators in your application

### Using the framework in a Seaside application

For instance in Seaside web application you could easily provide a custom session class holding the current translator:

```Smalltalk
WAExpirySession subclass: #MyAppSessionWithTranslation
  instanceVariableNames: 'translator'
	classVariableNames: ''
	category: 'MyApp-Web-Lifetime'
```

Also provide a getter:

```Smalltalk
translator 
	"Return the translator of the session - by default the english one"
	
	    translator ifNil: [ translator := I18NTranslator defaultTranslator ].
	    ^translator
```

In your web component class (typically a subclass of WAComponent) you can then access the translator easily like this:

```Smalltalk
    translator
    	^self session translator
```
    	
To provide translated texts (instead of hardcoded strings) easily rewrite your render methods like this:

```Smalltalk
    renderContentOn: html
    
        html paragraph: self translator welcome
```

Check out the Lighthouse sample application for more details.

### Tips and Tricks

An easy way of storing and managing translations is by combining the "I18N" project with the "[INIFile][6]" project. Although INI files are usually known from Windows operating system they can be used on other operating systems as well.

The interesting thing is that we can use the structure of an INI file very easily to manage our I18N requirements as languages can be mapped to INI file sections and key value pairs to the translations. We can also either have the translations internal to the Pharo image (so they can not be changed) or externally in a file and can also be corrected by the user of an application. 

Let's try with an example:

First load the project "INIFile" from the Pharo config browser. Now add a simple translation class:

```Smalltalk
Object subclass: #MyAppTranslations
    instanceVariableNames: ''
    classVariableNames: ''
    category: 'MyApp-Core-I18N'
```

On the class side of the new class implement the following class method:

```Smalltalk
    initFromStream: aStream

	    |iniFile|
	    iniFile := INIFile readFrom: aStream.
	    iniFile sectionsDo: [:section |
    		|translator|
    		translator := I18NTranslator newForLanguage: section label.
    		section associationsDo: [:each |
    			translator translationMap at: each key asSymbol put: each value ].	 
		    I18NTranslator addTranslator: translator.		
	    ]
```

and the class side #initialize method:

```Smalltalk
    initialize
	    self initFromStream: self comment readStream
```
	
The first method will read the translations from a given stream that is structured like an INI file (with sections and entries). And the clas initialize method will use the class comment of our **MyAppTranslations** class as the source for the translations. 

This way the translations will be initialized as soon as the class loads into the Pharo image and we can easily add the folling translations as a class comment in our MyAppTranslations class.  

```
    [EN]
    learnMore=Learn more
    login=Login
    loginTo=Sign in to {1}
    welcome=Welcome
    welcomeTo=Welcome to {1}
    
    [DE]
    learnMore=Erfahren Sie mehr
    login=Anmeldung
    loginTo={1} Anmeldung
    welcome=Willkommen
    welcomeTo=Willkommen bei {1}

    [FR]
    learnMore=En savoir plus
    login=Entrer
    loginTo=Connecter à {1}
    welcome=Accueil
    welcomeTo=Bienvenue sur le {1}

    [ES]
    learnMore=Obtenga más información
    login=Aplicación
    loginTo=Iniciar sesión en {1}
    welcome=Bienvenido
    welcomeTo=Bienvenido al {1}
```

Do not forget to call the #initialize method to (re)initialize the translations:

```Smalltalk
    MyAppTranslations initialize
```

Also check the translations in the translation viewer.

```Smalltalk
    I18NTranslationViewerApplication run

```

As before we can access the translations:

```Smalltalk
    I18NTranslator defaultTranslator welcomeTo format: #('Pharo')
```

should return 'Welcome to Pharo' while 

```Smalltalk
    (I18NTranslator forLanguage: 'FR') welcomeTo format: #('Pharo')  
```

should return the french translation: 'Bienvenue sur le Pharo'

So depending on own needs one can manage the translations externally in an INI file or directly within the image as a simple class comment. Using the later has the advantage that one can use the usual Pharo tools to checks modifications and store/version the translations together with the other application code.

## Summary
 
[I18N][7] is a framework to address the problem of translating applications and making them available to a wider audience. It is a simple "Smalltalk only" solution without any dependency to other external translation frameworks. One can use any source to manage the translations - an example was given for managing translations as an INIFile like structure. 


  [1]: http://www.pharo.org
  [2]: http://www.seaside.st
  [3]: https://github.com/astares/Pharo-I18N
  [4]: http://smalltalkhub.com/#!/~TorstenBergmann/Lighthouse
  [5]: https://ci.inria.fr/pharo-contribution/job/Lighthouse/
  [6]: https://github.com/astares/Pharo-INIFile
  [7]: https://github.com/astares/Pharo-I18N
