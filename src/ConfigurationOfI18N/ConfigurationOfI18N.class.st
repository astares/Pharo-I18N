"
# I18N

## Project info

The ""I18N"" project provides Internationalization support for applications written in [Pharo][1] (for instance [Seaside][2] applications). It allows for simple handling of multiple translations of an app without a dependency to other external frameworks (like GetText, ...).

### Project location
The project is located on STHub at [http://smalltalkhub.com/#!/~TorstenBergmann/I18N/][3]

### Demo

You can checkout a demo in the Lighthouse Seaside sample application. This project is [also on SmalltalkHub][4] and a ready to run image for ""Lighthouse"" can be found on the [Pharo Contribution CI][5] server. Lighthouse uses the I18N framework to provide  english, german, french, italian, spanish and arabic translation for a web user interface.

### License
The code of I18N is under MIT License.

## Installation
You can load the code either in Pharo 3.0 or Pharo 4.0 easily using the given script:

    Gofer new
        url: 'http://smalltalkhub.com/mc/TorstenBergmann/I18N/main';
        package: 'ConfigurationOfI18N';
        load.
    ((Smalltalk at: #ConfigurationOfI18N) project stableVersion) load.

## How to use
### The basic idea

The basic idea of the framework is instead of hardcoding texts and strings for labels, menu items or other in an application just provide a unique message key. Depending on a translator object this message key resolves to a translation in the specific natural language. So for instance the key #welcome should resolve to 'Welcome' in english, 'Willkommen' in german, 'Bienvenue' in french, ...

Also the framework should be very lean and easy to use in any application built on top of Pharo or maybe in Pharo as well.

### Translations

To perform it's tasks the framework includes a simple class called **""I18NTranslator""** that allows you to manage translators with translations in different languages. 

As the english language is often used to develop by default an english translator is available:

    I18NTranslator defaultTranslator inspect

In the inspector you will see that a translator is responsible for a language (using the ISO code) and manages a translation map.

To access all the translators use

    I18NTranslator translators inspect

So far we have only one translator who can also be accessed using:

    I18NTranslator forLanguage: 'EN'
    
## Adding translations

### Manually adding translations

Any translator has a translation map that has to be filled with translations in advance. We do this by using a unique message key (a symbol) and provide the translation:

    |translator|
    translator := I18NTranslator defaultTranslator.
    translator translationMap at: #welcome put: 'Welcome'

So 

    (I18NTranslator forLanguage: 'EN') translationMap isEmpty

should return *false* as we have added our first translation for the english language.

### Retrieving the translation again

If you have access to the translator the you can retrieve the given translation by just sending a message:

    I18NTranslator defaultTranslator welcome
    
This should return the 'Welcome' string as the translator we use currently cares about the english language.

*If you look at the implementation of class I18NTranslator you will see that this is handles by overriding #doesNotUnderstand: message. If there is a translation that matches the given selector then the translated string is returned, otherwise the message is handled as a usual Does Not Understand (DNU) message.*  

So far that was not very interesting, but let's move on:

### Translation viewer
After loading the framework you will find a tool called ""Translation viewer"" in the world menu. Just check the ""I18N Translations"" menu item. When you open the tool right after loading you will notice that the translations are empty.

If we add a translation and open the tool we will see our entry for the english language:

    |englishTranslator|
    englishTranslator := I18NTranslator defaultTranslator.
    englishTranslator translationMap at: #welcome put: 'Welcome'.
    I18NTranslationViewer open

### Adding more languages/translators

Now lets add another translator for a different language, we do this by instantiating a new translator object and registering it as a translator:

    |germanTranslator|
    germanTranslator := (I18NTranslator newForLanguage: 'DE').
    I18NTranslator addTranslator: germanTranslator.
    
To check if our translator is now a registered translator we can use the following expression:

    I18NTranslator translators inspect

Now two translators are registered with the framework - one for the english and one for german language. Lets open the translation viewer again:
    
    I18NTranslationViewer open

You will now notice that the viewer has a new column for the german language. But the entry for our welcome text is still set to nil.

So we have to make it complete and provide also a german translation for the same message key #welcome:

    |germanTranslator|
    germanTranslator := I18NTranslator forLanguage: 'DE'.
    germanTranslator translationMap at: #welcome put: 'Willkommen'.

If you now open the translation viewer you will see both translations: 'Welcome' for the english language and 'Willkommen' for german language registered with the given message key. So depending on the translator that one asks a different String is returned:

    (I18NTranslator forLanguage: 'DE') welcome.

returns 'Willkommen' and 

    (I18NTranslator forLanguage: 'DE') welcome.

returns 'Welcome'.

If we like we can easily add other languages like french:

    (I18NTranslator forLanguage: 'FR') translationMap at: #welcome put: 'Bienvenue'.

### Using the framework in an application

So the typical use case in an application is to:

  1. Load necessary translation from an external source (CSV, Database, ...) into the image
  2. Do not harcode strings but access them via a translator object (for instance via a global singleton that can be switched for your application).
  4. Allow you user to switch between translators in your application

### Using the framework in a Seaside application

For instance in Seaside web application you could easily provide a custom session class holding the current translator:

    WAExpirySession subclass: #MyAppSessionWithTranslation
	    instanceVariableNames: 'translator'
	    classVariableNames: ''
	    category: 'MyApp-Web-Lifetime'

Also provide a getter:

    translator 
	""Return the translator of the session - by default the english one""
	
	    translator ifNil: [ translator := I18NTranslator defaultTranslator ].
	    ^translator

In your web component class (typically a subclass of WAComponent) you can then access the translator easily like this:

    translator
    	^self session translator
    	
To provide translated texts (instead of hardcoded strings) easily rewrite your render methods like this:

    renderContentOn: html
    
        html paragraph: self translator welcome

Check out the Lighthouse sample application for more details.

### Tips and Tricks

An easy way of storing and managing translations is by combining the ""I18N"" project with the ""[INIFile][6]"" project. Although INI files are usually known from Windows operating system they can be used on other operating systems as well.

The interesting thing is that we can use the structure of an INI file very easily to manage our I18N requirements as languages can be mapped to INI file sections and key value pairs to the translations. We can also either have the translations internal to the Pharo image (so they can not be changed) or externally in a file and can also be corrected by the user of an application. 

Let's try with an example:

First load the project ""INIFile"" from the Pharo config browser. Now add a simple translation class:

      Object subclass: #MyAppTranslations
	    instanceVariableNames: ''
	    classVariableNames: ''
	    category: 'MyApp-Core-I18N'

On the class side of the new class implement the following class method:

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

and the class side #initialize method:

    initialize
	    self initFromStream: self comment readStream
	
The first method will read the translations from a given stream that is structured like an INI file (with sections and entries). And the clas initialize method will use the class comment of our **MyAppTranslations** class as the source for the translations. 

This way the translations will be initialized as soon as the class loads into the Pharo image and we can easily add the folling translations as a class comment in our MyAppTranslations class.  

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

Do not forget to call the #initialize method to (re)initialize the translations:

    MyAppTranslations initialize

Also check the translations in the translation viewer.

    I18NTranslationViewer open

As before we can access the translations:

    I18NTranslator defaultTranslator welcomeTo format: #('Pharo')

should return 'Welcome to Pharo' while 

    (I18NTranslator forLanguage: 'FR') welcomeTo format: #('Pharo')  

should return the french translation: 'Bienvenue sur le Pharo'

So depending on own needs one can manage the translations externally in an INI file or directly within the image as a simple class comment. Using the later has the advantage that one can use the usual Pharo tools to checks modifications and store/version the translations together with the other application code.

## Summary
 
[I18N][7] is a framework to address the problem of translating applications and making them available to a wider audience. It is a simple ""Smalltalk only"" solution without any dependency to other external translation frameworks. One can use any source to manage the translations - an example was given for managing translations as an INIFile like structure. 


  [1]: http://www.pharo.org
  [2]: http://www.seaside.st
  [3]: http://smalltalkhub.com/#!/~TorstenBergmann/I18N/
  [4]: http://smalltalkhub.com/#!/~TorstenBergmann/Lighthouse
  [5]: https://ci.inria.fr/pharo-contribution/job/Lighthouse/
  [6]: http://smalltalkhub.com/#!/~TorstenBergmann/INIFile
  [7]: http://smalltalkhub.com/#!/~TorstenBergmann/I18N/
"
Class {
	#name : #ConfigurationOfI18N,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfI18N
}

{ #category : #'development support' }
ConfigurationOfI18N class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfI18N class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #private }
ConfigurationOfI18N class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfI18N class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfI18N class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfI18N class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfI18N class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfI18N class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfI18N class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfI18N class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfI18N >> baseline01: spec [
	<version: '0.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/TorstenBergmann/I18N/main/'.
		spec 
			package: #'I18N-Core';
			package: #'I18N-Tests-Core' with: [
				spec requires: #(#'I18N-Core' ). ];
			package: #'I18N-Tools' with: [
				spec requires: #(#'I18N-Core' ). ].
		spec 
			group: 'Core' with: #(#'I18N-Core' );
			group: 'Tests' with: #(#'I18N-Tests-Core' );
			group: 'Tools' with: #(#'I18N-Tools' ). ].

]

{ #category : #accessing }
ConfigurationOfI18N >> customProjectAttributes [
	 "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes"

	^ #().
]

{ #category : #'symbolic versions' }
ConfigurationOfI18N >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '0.1-baseline'.

]

{ #category : #accessing }
ConfigurationOfI18N >> project [

	^ project ifNil: [ 
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		(Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfI18N >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '0.1.0'.

]

{ #category : #versions }
ConfigurationOfI18N >> version010: spec [
	<version: '0.1.0' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.1.0'.
		spec author: 'TorstenBergmann'.
		spec timestamp: '6/13/2014 17:16'.
		spec 
			package: #'I18N-Core' with: 'I18N-Core-TorstenBergmann.2';
			package: #'I18N-Tests-Core' with: 'I18N-Tests-Core-TorstenBergmann.2';
			package: #'I18N-Tools' with: 'I18N-Tools-TorstenBergmann.3'. ].

]
