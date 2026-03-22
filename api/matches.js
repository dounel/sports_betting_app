export default async function handler(req, res) {
  // Enable CORS pou tout orijin
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  // Si se yon preflight request (OPTIONS), reponn imedyatman
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Sèlman aksepte GET
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const { type, limit } = req.query;
  
  // API Key football-data.org
  const API_KEY = process.env.FOOTBALL_API_KEY || '396b03798bb52ede1863990b1fe633b3';
  
  // Konstrwi URL API a
  let status = 'SCHEDULED,LIVE,FINISHED';
  if (type === 'live') {
    status = 'LIVE,IN_PLAY';
  }
  
  const apiUrl = `https://api.football-data.org/v4/matches?status=${status}&limit=${limit || 50}`;

  try {
    const response = await fetch(apiUrl, {
      headers: {
        'X-Auth-Token': API_KEY,
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`API error: ${response.status}`);
    }

    const data = await response.json();
    
    // Retounen match yo
    res.status(200).json({
      matches: data.matches || [],
      count: data.matches?.length || 0,
    });
    
  } catch (error) {
    console.error('Error fetching matches:', error);
    res.status(500).json({ 
      error: 'Failed to fetch matches',
      matches: [],
      count: 0 
    });
  }
};
