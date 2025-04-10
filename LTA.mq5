// Define os nomes dos objetos
#define LINE_NAME_DINAMICA "LinhaDinamica"
#define LINE_NAME_FIXA "LinhaFixa"

// Variáveis globais para controlar o estado
double nivelMaisAlto = 0; // Armazena o nível mais alto que o preço atingiu
bool linhasCriadas = false; // Controla se as linhas já foram criadas

void OnTick() {
    double precoAtual = SymbolInfoDouble(_Symbol, SYMBOL_BID); // Obtém o preço atual
    double diferencaPips = 10 * 0.00001; // Converte a quantidade de pips
    double precoComDiferenca = precoAtual - diferencaPips; // Adiciona a diferença ao preço atual

    // Verifica se as linhas já foram criadas
    if (!linhasCriadas) {
        // Cria a linha dinâmica no preço com diferença
        ObjectCreate(ChartID(), LINE_NAME_DINAMICA, OBJ_HLINE, 0, 0, precoComDiferenca);
        ObjectSetInteger(0, LINE_NAME_DINAMICA, OBJPROP_COLOR, clrGreen);
        ObjectSetInteger(ChartID(), LINE_NAME_DINAMICA, OBJPROP_WIDTH, 2);

        // Cria a linha fixa no preço atual
        ObjectCreate(ChartID(), LINE_NAME_FIXA, OBJ_HLINE, 0, 0, precoAtual);
        ObjectSetInteger(ChartID(), LINE_NAME_FIXA, OBJPROP_COLOR, clrWhite);
        ObjectSetInteger(ChartID(), LINE_NAME_FIXA, OBJPROP_WIDTH, 1);

        // Inicializa o nível mais alto com o preço atual
        nivelMaisAlto = precoAtual;

        // Marca as linhas como criadas
        linhasCriadas = true;
    }

    // Verifica se o preço subiu acima do nível mais alto
    if (precoAtual > nivelMaisAlto) {
        // Atualiza o nível mais alto
        nivelMaisAlto = precoAtual;

        // Move a linha dinâmica para o novo preço com diferença
        ObjectSetDouble(ChartID(), LINE_NAME_DINAMICA, OBJPROP_PRICE, precoComDiferenca);
    }
}