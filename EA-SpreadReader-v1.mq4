//+------------------------------------------------------------------+
//|                                           EA-SpreadReader-v1.mql4|
//|                          Copyright 2024, David Martinez          |
//|                                      https://openai.com          |
//+------------------------------------------------------------------+
#property strict

// Entrada para determinar si se debe crear un nuevo archivo CSV o agregar al existente
input bool crearNuevoCSV = true;

// Nombre del archivo CSV
input string nombreArchivo = "spreads.csv";

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Si se debe crear un nuevo archivo CSV, borra el archivo existente
    if (crearNuevoCSV)
    {
        FileDelete(nombreArchivo);
    }

    // Escribir encabezado en el archivo CSV si es un nuevo archivo o si está vacío
    if (crearNuevoCSV && (!FileIsExist(nombreArchivo) || FileSize(nombreArchivo) == 0))
    {
        string header = "TimeStamp";
        // Obtener lista de símbolos en el Market Watch
        string symbols[] = {};
        int symbolsTotal = SymbolsTotal(true);
        for (int i = 0; i < symbolsTotal; i++)
        {
            string symbol = SymbolName(i, true);
            header += "," + symbol;
        }
        WriteCSVLine(nombreArchivo, header);
    }

    // Llamar a la función para registrar los spreads minuto a minuto
    EventSetTimer(60); // Llama la función OnTimer cada 60 segundos

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Detener el temporizador al finalizar el EA
    EventKillTimer();
}

//+------------------------------------------------------------------+
//| Expert timer function                                            |
//+------------------------------------------------------------------+
void OnTimer()
{
    string spreadData = TimeToStr(TimeLocal(), TIME_DATE | TIME_MINUTES);
    for (int i = 0; i < SymbolsTotal(true); i++)
    {
        string symbol = SymbolName(i, true);
        double spread = MarketInfo(symbol, MODE_SPREAD);
        spreadData += "," + DoubleToString(spread, 0);
    }
    WriteCSVLine(nombreArchivo, spreadData);
}

//+------------------------------------------------------------------+
//| Función para escribir una línea en un archivo CSV                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Función para escribir una línea en un archivo CSV                |
//+------------------------------------------------------------------+
void WriteCSVLine(const string fileName, const string data)
{
    int fileHandle = FileOpen(fileName, FILE_READ | FILE_WRITE | FILE_CSV, ';');
    if (fileHandle != INVALID_HANDLE)
    {
        FileSeek(fileHandle, 0, SEEK_END);
        FileWrite(fileHandle, data);
        //FileWrite(fileHandle, "\n");
        FileClose(fileHandle);
    }
    else
    {
        Print("Error al abrir el archivo: ", GetLastError());
    }
}


