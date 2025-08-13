# run-all.sh
#!/usr/bin/env bash
set -e

# Arranca el backend
uvicorn backend.main:app --reload --env-file .env &
BACK_PID=$!

# Arranca el frontend
(
  cd frontend
  npm run dev
) &
FRONT_PID=$!

# Detener los procesos al cerrar
trap "kill $BACK_PID $FRONT_PID" EXIT

# Esperar a que se cierre alguno
wait -n $BACK_PID $FRONT_PID
