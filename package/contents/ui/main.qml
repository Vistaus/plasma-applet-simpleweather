import QtQuick 2.7
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.weather 1.0 as WeatherPlugin

Item {
	id: widget

	WeatherData {
		id: weatherData
	}

	// Uncomment to test a specific size (Desktop Widget only)
	// width: 400
	// height: 400

	Plasmoid.icon: weatherData.currentConditionIconName
	Plasmoid.toolTipMainText: weatherData.currentConditions

	Plasmoid.fullRepresentation: Item {
		readonly property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
		Plasmoid.backgroundHints: isDesktopContainment && !plasmoid.configuration.showBackground ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground

		property Item contentItem: weatherData.needsConfiguring ? configureButton : forecastLayout
		implicitWidth: contentItem.implicitWidth
		implicitHeight: contentItem.implicitHeight
		Layout.minimumWidth: implicitWidth
		Layout.minimumHeight: implicitHeight

		PlasmaComponents.Button {
			id: configureButton
			anchors.centerIn: parent
			visible: weatherData.needsConfiguring
			text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Configure...")
			onClicked: plasmoid.action("configure").trigger()
		}

		ColumnLayout {
			id: forecastLayout
			anchors.fill: parent
			spacing: units.smallSpacing

			CurrentWeatherView {
				id: currentWeatherView
				Layout.alignment: Qt.AlignHCenter
			}

			NoticesListView {
				Layout.fillWidth: true
				model: weatherData.watchesModel
				readonly property bool showWatches: plasmoid.configuration.showWarnings
				visible: showWatches && model.length > 0
				state: "Watches"
				horizontalAlignment: Text.AlignHCenter
			}

			NoticesListView {
				Layout.fillWidth: true
				model: weatherData.warningsModel
				readonly property bool showWarnings: plasmoid.configuration.showWarnings
				visible: showWarnings && model.length > 0
				state: "Warnings"
				horizontalAlignment: Text.AlignHCenter
			}
		}

	}


	Component.onCompleted: {
		// plasmoid.action("configure").trigger()
	}
}
