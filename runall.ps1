# Arranca el backend en segundo plano
$backend = Start-Process "uvicorn" "backend.main:app --reload --env-file .env" -NoNewWindow -PassThru

# Arranca el frontend
Push-Location frontend
$frontend = Start-Process "npm" "run dev" -NoNewWindow -PassThru
Pop-Location

# Cuando el script termine, detener ambos procesos
# (al cerrar la ventana o presionar Ctrl+C)
$handler = {
  $backend | Stop-Process
  $frontend | Stop-Process
}
Register-EngineEvent PowerShell.Exiting -Action $handler | Out-Null

Wait-Process -Id $backend.Id -ErrorAction SilentlyContinue
Wait-Process -Id $frontend.Id -ErrorAction SilentlyContinue
