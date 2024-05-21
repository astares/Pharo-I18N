"
Baseline for [https://github.com/astares/Pharo-I18N](https://github.com/astares/Pharo-I18N)
"
Class {
	#name : 'BaselineOfI18N',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfI18N-Base',
	#package : 'BaselineOfI18N',
	#tag : 'Base'
}

{ #category : 'baselines' }
BaselineOfI18N >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		"Packages"
		spec 
			package: 'I18N-Core';
			package: 'I18N-Tests-Core' with: [ spec requires: #('I18N-Core') ];
			package: 'I18N-Tools' with: [ spec requires: #('I18N-Core') ].
			
		"Groups"	
		spec 
			group: 'Core' with: #('I18N-Core');
			group: 'Tools' with: #('I18N-Tools');
			group: 'Tests' with: #('I18N-Tests-Core');
			group: 'CI' with: #('Tests').

		"Virtual groups"	
		spec	
			group: 'all' with: #('Core' 'Tools' 'Tests');
			group: 'default' with: #('all' ) ]
]
