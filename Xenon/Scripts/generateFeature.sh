#!/bin/bash

while true; do
    echo -n "enter name of the Feature (e.g. NetworkingFeature): "
    read name
    projectPath=Projects/Feature/$name
    if [ -e "$projectPath" ]; then
        echo "Feature already exist"
    else
        break
    fi
done

while true; do
    echo -n "add Example App? (y, n): "
    read addExample
    if [ "$addExample" = "Y" ] || [ "$addExample" = "y" ] || [ "$addExample" = "N" ] || [ "$addExample" = "n" ]; then
        break
    fi
done

while true; do
    echo -n "add Dependancy to your App? (y, n): "
    read addDependancy
    if [ "$addDependancy" = "Y" ] || [ "$addDependancy" = "y" ] || [ "$addDependancy" = "N" ] || [ "$addDependancy" = "n" ]; then
        break
    fi
done

modulePath="Plugin/UtilityPlugin/ProjectDescriptionHelpers/ModulePath.swift"
FeatureEnum="public enum Feature: String {"

sed -i "" "$(sed -n "/$FeatureEnum/=" $modulePath | tail -n 1)s/.*/$FeatureEnum\n        case $name/" $modulePath

mkdir $projectPath

if [ "$addExample" = "Y" ] || [ "$addExample" = "y" ]; then

    mkdir $projectPath/Example
    cp -af Template/* $projectPath/Example

    exampleAppContent='
        .makeExampleApp(name: ModulePaths.feature(.'$name').name, dependencies: [
            .target(name: ModulePaths.feature(.'$name').name)
        ])
'
fi


cat <<EOF >> $projectPath/Project.swift
import ProjectDescription
import UtilityPlugin
import ProjectDescriptionHelpers

let project = Project.module(
    .feature(.$name),
    product: .framework, targets: [$exampleAppContent],
    dependencies: [
        
    ]
)
EOF

cp -af Template/Resources $projectPath
mkdir $projectPath/Sources
touch $projectPath/Sources/Template.swift


if [ "$addDependancy" = "Y" ] || [ "$addDependancy" = "y" ]; then
    appPath=Projects/App
    makeAppLine=$(sed -n "/.makeApp(name: ProjectInfo.name/=" $appPath/Project.swift)
    makeAppLineData=$(sed -n ''$makeAppLine'p' $appPath/Project.swift)
    addedContent='ModulePaths.feature(.'$name').dependency,'
    content="$makeAppLineData\n        $addedContent"
    sed -i "" "${makeAppLine}s/.*/${content}/" "$appPath/Project.swift"
fi
