<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mining Calculator - MT Solutions</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #000;
            color: #fff;
            margin: 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }
        .container {
            max-width: 800px;
            width: 100%;
            background-color: #1a1a1a;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
            text-align: center;
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-column-gap: 20px;
            margin-top: 90px;
        }
        .title {
            font-size: 28px;
            margin-bottom: 20px;
            color: #4CAF50;
            grid-column: span 2;
            text-align: center;
        }
        .input-label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
            text-align: left;
            color: #fff;
        }
        .input-field {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #333;
            border-radius: 6px;
            box-sizing: border-box;
            margin-bottom: 15px;
            background-color: #333;
            color: #fff;
            outline: none;
            text-align: right;
        }
        .submit-button {
            background-color: #4CAF50;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 18px;
            width: 100%;
            margin-top: 15px;
        }
        .submit-button:hover {
            background-color: #45a049;
        }
        .data-section {
            grid-column: 2 / 3;
            text-align: left;
            color: #fff;
            margin-top: 30px;
        }
        .result-container {
            grid-column: 2 / 3;
            border-top: 1px solid #444;
            padding-top: 15px;
            text-align: left;
            margin-top: 20px;
            display: none;
        }
        .result-label {
            font-weight: bold;
            color: #4CAF50;
            text-align: left;
            display: block;
            margin-top: 20px;
        }
        .result-value {
            margin-top: 5px;
            font-size: 16px;
            text-align: left;
            color: #fff;
            border: 1px solid #333;
            border-radius: 6px;
            padding: 10px;
            background-color: #333;
            width: 100%;
            box-sizing: border-box;
            pointer-events: none; /* No se puede hacer clic ni editar */
            opacity: 0.7; /* Opacidad para indicar que no es editable */
        }
        .result-value span {
            font-weight: normal;
            color: #fff;
            display: block;
            margin-top: 5px;
        }
        .green-text {
            color: #4CAF50;
            font-weight: bold;
            text-decoration: underline;
        }
        .loading {
            color: #4CAF50;
            margin-bottom: 20px;
            grid-column: span 2;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="title">Mining Calculator - MT Solutions</div>
        <div id="loading" class="loading">Cargando datos...</div>
        <form id="calculator-form">
            <div class="input-section">
                <label for="hashrateMinero" class="input-label">Hashrate del Minero (TH/s):</label>
                <input type="text" id="hashrateMinero" name="hashrateMinero" class="input-field" required>
            </div>

            <div class="input-section">
                <label for="precioBTC" class="input-label">Precio actual del BTC (USD):</label>
                <input type="text" id="precioBTC" name="precioBTC" class="input-field" required>
            </div>

            <div class="input-section">
                <label for="hashrateRed" class="input-label">Hashrate de la Red (TH/s):</label>
                <input type="text" id="hashrateRed" name="hashrateRed" class="input-field" required>
            </div>

            <div class="input-section">
                <label for="costoEnergia" class="input-label">Costo de Energía (USD/kWh):</label>
                <input type="text" id="costoEnergia" name="costoEnergia" class="input-field" required>
            </div>

            <div class="input-section">
                <label for="consumoEnergia" class="input-label">Consumo de Energía (kWh/día):</label>
                <input type="text" id="consumoEnergia" name="consumoEnergia" class="input-field" required>
            </div>

            <button type="submit" class="submit-button">Calcular</button>
        </form>

        <div class="data-section">
            <div class="result-label">Datos fijos para cálculo:</div>
            <div class="result-value"><span class="input-label">Recompensa por Bloque:</span> 3.125 BTC</div>
            <div class="result-value"><span class="input-label">Bloques por Día:</span> 144</div>
            <div class="result-value"><span class="input-label">Días por Mes:</span> 30</div>
        </div>

        <div class="result-container" id="result-container">
            <div class="result-label">Resultados:</div>
            <div class="result-value"><span class="input-label">Recompensa Diaria:</span> <span id="recompensaDiaria"></span></div>
            <div class="result-value"><span class="input-label">Recompensa Mensual:</span> <span id="recompensaMensual"></span></div>
            <div class="result-value"><span class="input-label">Valor Mensual en USD:</span> <span id="valorMensual"></span></div>
            <div class="result-value"><span class="input-label">Costo de Energía Mensual USD:</span> <span id="costoEnergiaMensual"></span></div>
            <div class="result-value"><span class="input-label">Producción Neta Mensual USD:</span> <span id="produccionNeta" class="green-text"></span></div>
        </div>
    </div>

    <script>
        // Función para obtener el precio actual de BTC
        async function obtenerPrecioBTC() {
            try {
                const response = await fetch('https://api.coindesk.com/v1/bpi/currentprice/BTC.json');
                const data = await response.json();
                return parseFloat(data.bpi.USD.rate.replace(',', ''));
            } catch (error) {
                console.error('Error al obtener el precio de BTC:', error);
                return null;
            }
        }

        // Función para obtener el hashrate de la red desde otra fuente
        async function obtenerHashrateRed() {
            try {
                const response = await fetch('https://min-api.cryptocompare.com/data/stats/global');
                const data = await response.json();
                return parseFloat(data.total_hash_rate_24hrs.BTC);
            } catch (error) {
                console.error('Error al obtener el hashrate de la red:', error);
                return null;
            }
        }

        document.addEventListener('DOMContentLoaded', async function() {
            const precioBTC = await obtenerPrecioBTC();
            const hashrateRed = await obtenerHashrateRed();

            if (precioBTC !== null) {
                document.getElementById('precioBTC').value = precioBTC.toFixed(2);
            }
            if (hashrateRed !== null) {
                document.getElementById('hashrateRed').value = (hashrateRed / 1e12).toFixed(2) + ' TH/s';
            }

            document.getElementById('loading').style.display = 'none';
            document.getElementById('calculator-form').style.display = 'block';
        });

        document.getElementById('calculator-form').addEventListener('submit', function(event) {
            event.preventDefault();

            // Obtener valores de entrada
            var hashrateMinero = parseFloat(document.getElementById('hashrateMinero').value);
            var precioBTC = parseFloat(document.getElementById('precioBTC').value);
            var hashrateRed = parseFloat(document.getElementById('hashrateRed').value);
            var costoEnergiaUSD = parseFloat(document.getElementById('costoEnergia').value);
            var consumoEnergiaKWH = parseFloat(document.getElementById('consumoEnergia').value);

            // Datos fijos para cálculo
            const recompensaPorBloque = 3.125;
            const bloquesPorDia = 144;
            const diasPorMes = 30;

            // Calcular recompensa diaria en BTC
            var recompensaDiariaBTC = (hashrateMinero / hashrateRed) * recompensaPorBloque * bloquesPorDia;

            // Calcular recompensa mensual en BTC
            var recompensaMensualBTC = recompensaDiariaBTC * diasPorMes;

            // Calcular valor mensual en USD
            var valorMensualUSD = recompensaMensualBTC * precioBTC;

            // Calcular costo de energía mensual en USD
            var costoEnergiaMensualUSD = costoEnergiaUSD * consumoEnergiaKWH * diasPorMes;

            // Calcular producción neta mensual en USD
            var produccionNetaUSD = valorMensualUSD - costoEnergiaMensualUSD;

            // Mostrar resultados en la interfaz
            document.getElementById('recompensaDiaria').textContent = recompensaDiariaBTC.toFixed(6) + ' BTC';
            document.getElementById('recompensaMensual').textContent = recompensaMensualBTC.toFixed(6) + ' BTC';
            document.getElementById('valorMensual').textContent = '$' + valorMensualUSD.toFixed(2);
            document.getElementById('costoEnergiaMensual').textContent = '$' + costoEnergiaMensualUSD.toFixed(2);
            document.getElementById('produccionNeta').textContent = '$' + produccionNetaUSD.toFixed(2);

            document.getElementById('result-container').style.display = 'block';
            document.getElementById('result-container').scrollIntoView({ behavior: 'smooth', block: 'start' });
        });
    </script>
</body>
</html>
