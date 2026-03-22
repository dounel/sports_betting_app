module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const { type } = req.query;
  const API_KEY = process.env.FOOTBALL_API_KEY || '396b03798bb52ede1863990b1fe633b3';
  
  // Sèvi ak dat jodi a
  const today = new Date().toISOString().split('T')[0];
  const apiUrl = `https://api.football-data.org/v4/matches?dateFrom=${today}&dateTo=${today}`;

  try {
    const response = await fetch(apiUrl, {
      headers: { 'X-Auth-Token': API_KEY },
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`API error: ${response.status} - ${errorText}`);
    }

    const data = await response.json();
    let matches = data.matches || [];
    
    // Filtre pa tip (live oswa tout)
    if (type === 'live') {
      matches = matches.filter(m => m.status === 'LIVE' || m.status === 'IN_PLAY');
    }
    
    // Limite kantite match
    matches = matches.slice(0, 50);
    
    res.status(200).json({ matches, count: matches.length });
  } catch (error) {
    res.status(200).json({ 
      error: error.message,
      matches: [],
      count: 0 
    });
  }
};
