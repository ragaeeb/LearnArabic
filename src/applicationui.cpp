#include "precompiled.h"

#include "applicationui.hpp"
#include "Logger.h"

namespace arabic {

using namespace bb::cascades;

ApplicationUI::ApplicationUI(Application *app) : QObject(app), m_sceneCover("Cover.qml")
{
	INIT_SETTING("animations", 1);
	INIT_SETTING("voice", "female0");

	qmlRegisterType<QTimer>("com.canadainc.data", 1, 0, "QTimer");

	QmlDocument* qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml->setContextProperty("persist", &m_persistance);
    qml->setContextProperty("app", this);

    AbstractPane* root = qml->createRootObject<AbstractPane>();
    app->setScene(root);
}


void ApplicationUI::create(Application* app) {
	new ApplicationUI(app);
}


ApplicationUI::~ApplicationUI()
{
}

} // arabic
