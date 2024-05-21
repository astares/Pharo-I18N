Class {
	#name : 'BaselineOfI18N',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfI18N',
	#package : 'BaselineOfI18N'
}

{ #category : 'baselines' }
BaselineOfI18N >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		"Packages"
		spec 
			package: 'I18N-Core';
			package: 'I18N-Tests-Core' with: [ spec requires: #('I18N-Core' ) ];
			package: 'I18N-Tools' with: [ spec requires: #('I18N-Core' ) ].
			
		"Groups"	
		spec 
			group: 'Core' with: #('I18N-Core' );
			group: 'Tools' with: #('I18N-Tools' );
			group: 'Tests' with: #('I18N-Tests-Core' );
			group: 'all' with: #('Core' 'Tools' 'Tests' );
			group: 'default' with: #('all' ) ]
]
