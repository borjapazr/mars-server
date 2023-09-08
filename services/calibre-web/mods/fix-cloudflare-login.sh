#!/bin/bash

echo "**** patching calibre-web - removing session protection ****"

sed -i "/lm.session_protection = 'strong'/d" /app/calibre-web/cps/__init__.py
sed -i "/if not ub.check_user_session(current_user.id, flask_session.get('_id')) and 'opds' not in request.path:/d" /app/calibre-web/cps/admin.py
sed -i "/logout_user()/d" /app/calibre-web/cps/admin.py
