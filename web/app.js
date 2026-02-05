// Habitat Meal Tracker POC - Frontend

const API_BASE = '';

// State
let selectedMealType = null;
let currentAnalysis = null;

// DOM Elements
const mealInput = document.getElementById('mealInput');
const analyzeBtn = document.getElementById('analyzeBtn');
const analysisResult = document.getElementById('analysisResult');
const errorDisplay = document.getElementById('errorDisplay');
const loadingState = document.getElementById('loadingState');
const mealTimeline = document.getElementById('mealTimeline');

// Meal type buttons
const mealTypeBtns = document.querySelectorAll('.meal-type-btn');

// Result elements
const resultCalories = document.getElementById('resultCalories');
const resultProtein = document.getElementById('resultProtein');
const resultCarbs = document.getElementById('resultCarbs');
const resultFat = document.getElementById('resultFat');
const resultConfidence = document.getElementById('resultConfidence');
const warningsDiv = document.getElementById('warnings');
const errorMessage = document.getElementById('errorMessage');

// Total elements
const totalCalories = document.getElementById('totalCalories');
const totalProtein = document.getElementById('totalProtein');
const totalCarbs = document.getElementById('totalCarbs');
const totalFat = document.getElementById('totalFat');

// Buttons
const saveBtn = document.getElementById('saveBtn');
const discardBtn = document.getElementById('discardBtn');
const retryBtn = document.getElementById('retryBtn');

// LocalStorage key (keyed by date)
function getStorageKey() {
  const today = new Date().toISOString().split('T')[0];
  return `habitat_meals_${today}`;
}

// Load meals from localStorage
function loadMeals() {
  const key = getStorageKey();
  const data = localStorage.getItem(key);
  return data ? JSON.parse(data) : [];
}

// Save meals to localStorage
function saveMeals(meals) {
  const key = getStorageKey();
  localStorage.setItem(key, JSON.stringify(meals));
}

// Calculate daily totals
function calculateTotals(meals) {
  return meals.reduce((acc, meal) => ({
    calories: acc.calories + (meal.macros?.calories || 0),
    protein: acc.protein + (meal.macros?.protein_g || 0),
    carbs: acc.carbs + (meal.macros?.carbs_g || 0),
    fat: acc.fat + (meal.macros?.fat_g || 0),
  }), { calories: 0, protein: 0, carbs: 0, fat: 0 });
}

// Update daily totals display
function updateTotalsDisplay() {
  const meals = loadMeals();
  const totals = calculateTotals(meals);
  
  totalCalories.textContent = Math.round(totals.calories);
  totalProtein.textContent = Math.round(totals.protein) + 'g';
  totalCarbs.textContent = Math.round(totals.carbs) + 'g';
  totalFat.textContent = Math.round(totals.fat) + 'g';
}

// Format time for display
function formatTime(isoString) {
  const date = new Date(isoString);
  return date.toLocaleTimeString('en-US', { 
    hour: 'numeric', 
    minute: '2-digit',
    hour12: true 
  });
}

// Render meal timeline
function renderTimeline() {
  const meals = loadMeals();
  
  if (meals.length === 0) {
    mealTimeline.innerHTML = '<p class="empty-state">No meals logged yet</p>';
    return;
  }
  
  // Sort by timestamp, newest first
  const sorted = [...meals].sort((a, b) => 
    new Date(b.timestamp) - new Date(a.timestamp)
  );
  
  mealTimeline.innerHTML = sorted.map(meal => {
    const breakdownHtml = meal.breakdown && meal.breakdown.length > 0 
      ? `<div class="meal-breakdown collapsed" onclick="this.classList.toggle('collapsed')">
          <div class="breakdown-toggle">
            <span class="toggle-icon">▶</span>
            <span>Show ingredients (${meal.breakdown.length})</span>
          </div>
          <table class="breakdown-table-mini">
            <tbody>
              ${meal.breakdown.map(item => `
                <tr>
                  <td>${escapeHtml(item.food)}</td>
                  <td>${item.weight_g}g</td>
                  <td>${item.calories} kcal</td>
                  <td>${item.protein_g}g</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>`
      : '';
    
    return `
    <div class="meal-entry">
      <div class="meal-header">
        <span class="meal-type">${meal.mealType || 'Meal'}</span>
        <span class="meal-time">${formatTime(meal.timestamp)}</span>
      </div>
      <p class="meal-description">${escapeHtml(meal.rawInput || meal.normalizedText || meal.rawText)}</p>
      <div class="meal-macros">
        <span><span class="value">${meal.macros?.calories || 0}</span> kcal</span>
        <span><span class="value">${meal.macros?.protein_g || 0}g</span> protein</span>
        <span><span class="value">${meal.macros?.carbs_g || 0}g</span> carbs</span>
        <span><span class="value">${meal.macros?.fat_g || 0}g</span> fat</span>
      </div>
      ${breakdownHtml}
    </div>
  `;
  }).join('');
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// Show/hide UI states
function showState(state) {
  analysisResult.classList.add('hidden');
  errorDisplay.classList.add('hidden');
  loadingState.classList.add('hidden');
  
  switch (state) {
    case 'result':
      analysisResult.classList.remove('hidden');
      break;
    case 'error':
      errorDisplay.classList.remove('hidden');
      break;
    case 'loading':
      loadingState.classList.remove('hidden');
      break;
  }
}

// Analyze meal
async function analyzeMeal() {
  const text = mealInput.value.trim();
  
  if (!text) {
    errorMessage.textContent = 'Please enter a meal description';
    showState('error');
    return;
  }
  
  showState('loading');
  analyzeBtn.disabled = true;
  
  try {
    const response = await fetch(`${API_BASE}/v1/meals/analyze`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        text,
        mealType: selectedMealType,
        timestamp: new Date().toISOString(),
      }),
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.error?.message || 'Analysis failed');
    }
    
    // Store analysis result
    currentAnalysis = {
      ...data,
      rawInput: text,  // Original user input
      rawText: text,   // Keep for backwards compatibility
      mealType: selectedMealType,
      timestamp: new Date().toISOString(),
    };
    
    // Display results
    resultCalories.textContent = data.macros.calories;
    resultProtein.textContent = data.macros.protein_g + 'g';
    resultCarbs.textContent = data.macros.carbs_g + 'g';
    resultFat.textContent = data.macros.fat_g + 'g';
    
    // Show weight and confidence
    const weightInfo = data.totalWeight_g ? ` (${data.totalWeight_g}g total)` : '';
    resultConfidence.textContent = Math.round((data.confidence || 0) * 100) + '%' + weightInfo;
    
    // Display ingredient breakdown
    if (data.breakdown && data.breakdown.length > 0) {
      const breakdownHtml = `
        <div class="breakdown-section">
          <div class="breakdown-header">Per ingredient:</div>
          <table class="breakdown-table">
            <thead>
              <tr>
                <th>Food</th>
                <th>Weight</th>
                <th>Kcal</th>
                <th>Protein</th>
              </tr>
            </thead>
            <tbody>
              ${data.breakdown.map(item => `
                <tr>
                  <td>${escapeHtml(item.food)}</td>
                  <td>${item.weight_g}g</td>
                  <td>${item.calories}</td>
                  <td>${item.protein_g}g</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      `;
      warningsDiv.innerHTML = breakdownHtml;
    } else {
      warningsDiv.innerHTML = '';
    }
    
    // Display warnings
    if (data.warnings && data.warnings.length > 0) {
      warningsDiv.innerHTML += data.warnings.map(w => 
        `<div class="warning-item">⚠️ ${escapeHtml(w)}</div>`
      ).join('');
    }
    
    showState('result');
    
  } catch (error) {
    errorMessage.textContent = error.message;
    showState('error');
  } finally {
    analyzeBtn.disabled = false;
  }
}

// Save meal
function saveMeal() {
  if (!currentAnalysis) return;
  
  const meals = loadMeals();
  
  const mealEntry = {
    id: crypto.randomUUID(),
    timestamp: currentAnalysis.timestamp,
    mealType: currentAnalysis.mealType,
    rawInput: currentAnalysis.rawInput,  // Original user input
    rawText: currentAnalysis.rawText,
    normalizedText: currentAnalysis.normalizedText,
    parsedIngredients: currentAnalysis.parsedIngredients,
    breakdown: currentAnalysis.breakdown,
    macros: currentAnalysis.macros,
    totalWeight_g: currentAnalysis.totalWeight_g,
    source: currentAnalysis.source,
    confidence: currentAnalysis.confidence,
  };
  
  meals.push(mealEntry);
  saveMeals(meals);
  
  // Reset form
  resetForm();
  
  // Update UI
  updateTotalsDisplay();
  renderTimeline();
}

// Discard analysis
function discardAnalysis() {
  currentAnalysis = null;
  showState(null);
}

// Reset form
function resetForm() {
  mealInput.value = '';
  selectedMealType = null;
  currentAnalysis = null;
  
  mealTypeBtns.forEach(btn => btn.classList.remove('selected'));
  showState(null);
}

// Event Listeners
mealTypeBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    mealTypeBtns.forEach(b => b.classList.remove('selected'));
    btn.classList.add('selected');
    selectedMealType = btn.dataset.type;
  });
});

analyzeBtn.addEventListener('click', analyzeMeal);
saveBtn.addEventListener('click', saveMeal);
discardBtn.addEventListener('click', discardAnalysis);
retryBtn.addEventListener('click', () => showState(null));

// Allow Enter+Cmd/Ctrl to analyze
mealInput.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) {
    analyzeMeal();
  }
});

// Initialize on load
document.addEventListener('DOMContentLoaded', () => {
  updateTotalsDisplay();
  renderTimeline();
});
